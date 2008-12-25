module SGF
  class Game < Array
    def write_var(file,end_node)
      begin
        File.open(file, "w+") do |f|
          f.puts print_var(end_node)
        end
      rescue
        $stderr.puts "Error writing file: #{file}"
      end
    end
    
    def write_file(file)
      begin
        File.open(file, "w+") do |f|
          f.puts self.to_s
        end
      rescue
        $stderr.puts "Error writing file: #{file}"
      end
    end

    def print_var(end_node)
      stack = []
      c = end_node
      while c
        stack.push(c)
        c = c.prev
      end

      str = "\n("
      while c = stack.pop
        str << c.to_s
      end

      str << ")"
    end

    def print_tree(root)
      str = ''
      c = root
      str << "\n("
      str << c.to_s
      c=c.next
      while c and c.var_next.nil?
        str << c.to_s
        c = c.next
      end
      while not c.nil?
        str << print_tree(c)
        c = c.var_next
      end
      str << ")"
    end

    def to_s
      str = ''
      each do | root| 
        str << print_tree( root)
      end
      str << "\n"
    end
  end
end