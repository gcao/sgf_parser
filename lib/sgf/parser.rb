require 'sgf/game'
require 'sgf/node'

module SGF
  class SGFError < StandardError
    attr :retr

    def initialize(msg, retr = false)
      super(msg)
      @retr = retr
    end
  end

  class PropertyError < SGFError
  end

  class IOString
    def initialize(data)
      @data = data
      @index = 0
    end

    def getc
      c = @data[@index]
      @index += 1
      c
    end

    def ungetc(c)
      @index -= 1
    end

    def eof?
      @index >= @data.length
    end

    def rewind
      @index = 0
    end
  end

  class Parser
    def parse_node(data)
      @inp = IOString.new(data)
      node = Node.new
      while not @inp.eof?
        prop = read_prop
        node.push(prop)
      end
      return node
    end

    def parse_file(file)
      File.open(file) { |@inp| parse }
    end

    def parse(data)
      @inp = IOString.new(data)
      parse_input
    end

    private

    def parse_input
      @old_format = false
      @read_mode = 'normal'

      begin
        while not @inp.eof?
          c = getchar
          if c == ?(
            push(read_tree)
          end
        end
      rescue SGFError => e
        $stderr.puts e.message
        if e.retr
          puts("Trying to import from other format")
          @read_mode = 'gifus'
          @inp.rewind
          c = getchar
          c = getchar while c != ?(
          push(read_gifus_tree)
        else
          raise
        end
      end

      $stderr.puts "Warning: old SGF format detected" if @old_format
    end

    def getchar
      c = @inp.getc
      c = @inp.getc while c== ?\n or c==?\r or c ==?\t or c==32

      return c
    end

    def add_var(current,root_node)
      if current.next.nil?
        current.next = root_node
        root_node.c_var = ?A
        root_node.prev = current
      else
        c = current.next
        c = c.var_next while c.var_next
        c.var_next = root_node
        root_node.c_var = c.c_var + 1
        root_node.var_prev = c
        root_node.prev = current
      end
    end

    def read_gifus_tree
      vars = []
      root = Node.new
      root.c_var = ?A
      current = root
      while not @inp.eof?
        c = getchar
        if c == ?)
          return root
        elsif c == ?(
          vars.push(read_gifus_var)
        elsif c == ?;
          unless current.empty?
            n = Node.new
            current.next = n
            n.prev = current
            n.c_var = current.c_var
            unless vars.empty?
              vars.each { |v| add_var(current,v) }
              vars = []
            end
            current = n
          end
        else
          @inp.ungetc(c)
          begin
            p = read_prop
            if p.ident == 'TE'
              prop = Property.create('GN')
              prop.push(p.values[0])
            elsif p.ident == 'RD'
              prop= Property.create('DT')
              prop.push(p.values[0])
            elsif p.ident == 'KO'
              prop = Property.create('KM')
              prop.push(p.values[0])
            else
              prop = p
            end

            current.push(prop)
          rescue
            # bad property: try to skip 
            debug "skip: "+$!
            c = @inp.getc while c != ?\n and c != ?\;
            @inp.ungetc(c)
          end
        end
      end
    end

    #pt18 == ref 17-x
    def read_gifus_var
      root = Node.new
      current = root

      while not @inp.eof?
        c = getchar
        if c == ?)
          return root
        elsif c == ?;
          n = Node.new
          current.next = n
          n.prev = current
          n.c_var = current.c_var
          current = n
        else
          @inp.ungetc(c)
          begin
            p = read_prop
            if p.ident == 'RN' 
              # gifus detected
            elsif p.ident == 'PT'
              i = p.values[0].to_i 
              i.times { c = getchar;
                while c != ?;
                  c= getchar 
                  return root if c == ?)
                end
              }
            else    
              current.push(p)
            end
          rescue
            # bad property: try to skip 
            debug "skip: "+$!
            putc c = @inp.getc while c != ?\n and c != ?\;
            puts
            @inp.ungetc(c)
          end
        end
      end
    end

    def read_tree
      bogus = false
      root = Node.new
      root.c_var = ?A
      current = root
      while not @inp.eof?
        c = getchar
        if c == ?)
          return root
        elsif c == ?(
          add_var(current,read_tree) 
          # should not be another node after a variation
          bogus = true
        elsif c == ?;
          unless current.empty?
            n = Node.new
            current.next = n
            n.prev = current
            n.c_var = current.c_var
            current = n
          end
        else
          if bogus
            raise SGFError.new('Node after tree',true)
          end
          @inp.ungetc(c)
          begin 
            p = read_prop
            raise SGFError.new('gifus file detected',true) if p.ident == 'TE' and current == root
            # missing ";" in a node
            if (p.ident == 'W' or  p.ident == 'B') and (current.props.has_key?('B') or current.props.has_key?('W') )
              $stderr.puts("malformed node: #{p.to_s}\n")
              n = Node.new
              current.next = n
              n.prev = current
              n.c_var = current.c_var
              current = n
            end
            current.push(p)
          rescue PropertyError
            # bad property: try to skip 
            $stderr.puts("skip: "+$!)
            c = @inp.getc while c != ?\n and c != ?\;

            @inp.ungetc(c)
          end
        end
      end

      raise(SGFError.new,'end of file reached after: '+buf)
    end

    def read_prop
      name = read_prop_name
      raise PropertyError.new('bad property') if name.empty?
      prop = Property.create(name)
      read_contents(prop)
      return prop
    end

    def read_prop_name
      buf = ''
      while not @inp.eof?
        c = getchar
        if c.between?(?A,?Z)
          buf << c
        elsif c.between?(?a, ?z)
          @old_format = true
        else
          @inp.ungetc(c)
          return buf
        end
      end 

      raise(SGFError.new,'end of file reached after: ' + buf)
    end

    def read_contents(prop)
      while not @inp.eof?
        c = getchar
        if c == ?[
          if prop.ident == 'C'  or prop.ident == 'GN'
            prop.push(read_text)
          else
            prop.push(read_value)
          end
        else
          @inp.ungetc(c)
          return
        end 
      end
    end

    def read_value
      str = ''
      while not @inp.eof?
        c = getchar
        # skip \
        if c == ?\\
          c = getchar
          str << c
        elsif c == ?]
          return str
        elsif c == ?\r
          #skip \r
        else
          str << c
        end
      end

      raise(SGFError.new,'end of file reached after: ' + str)
    end

    def read_text
      cpt = 1
      str =''
      while not @inp.eof?
        c = @inp.getc
        # skip \
        if c == ?\\
          c = getchar
          str << c
        elsif c == ?[
          cpt += 1
          str << c
        elsif c == ?]
          cpt -= 1 
          if cpt == 0 or @read_mode == 'normal'
            return str
          else 
            str << c
          end
        elsif c == ?\r
          #skip \r
        else
          str << c
        end
      end

      raise(SGFError,'end of file reached')
    end
  end
end