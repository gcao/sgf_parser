module SGF
  class Property
    attr_reader :ident, :values

    def initialize(ident)
      @ident = ident
      @values = Array.new
    end

    def to_s
      buf = ''
      buf << @ident
      @values.each { |str| buf << '['+ str.to_s + ']' }
      buf
    end

    def action(g)
    end

    def undo(g)
    end

    def push(val)
      @values.push(val)
    end
    
    def set_node(node)
      @node = node
    end

    def <=>(other)
      return( self.prior <=> other.prior)
    end
  end

  class PUnknown < Property
  end

  module Coords
    def a_to_i(char)
      Coords.a_to_i(char)
    end

    def Coords.a_to_i(char)
      if char.nil?
        $stderr.puts "hmmmm I think there is a bug round here:"
        $stderr.puts caller
      end
      begin
        if char >= ?a and char <= ?z
          char - ?a
        elsif char >= ?A and char <= ?Z
          char - ?A
        end
      rescue
        raise(SGFError,"error in coords: " + self.inspect)
      end
    end

    def Coords.to_a(x,y)
      '' << ?a + x << ?a + y
    end

    def each_coords
      @values.each do |str|
        if str =~ /(..):(..)/
          c1 = a_to_i( $1[0])
          r1 = a_to_i( $1[1])
          c2 = a_to_i( $2[0])
          r2 = a_to_i( $2[1])

          c = r = 0

          for c in c1..c2
            for r in r1..r2
              yield(c, r)
            end
          end
        else
          yield(a_to_i(str[0]),a_to_i(str[1]))
        end
      end
    end

    def each_zone
      @values.each do |str|
        if str =~ /(..):(..)/
          c1= a_to_i( $1[0])
          r1= a_to_i( $1[1])
          c2= a_to_i( $2[0])
          r2= a_to_i( $2[1])
        else
          c1= a_to_i(str[0])
          r1= a_to_i(str[1])
          c2= c1
          r2= r1
        end
        yield(c1,r1,c2,r2)
      end
    end

    def Coords.simple_to_ary(str)
      if  str =~ /(..):(..)/
        c1= Coords.a_to_i( $1[0])
        r1= Coords.a_to_i( $1[1])
        c2= Coords.a_to_i( $2[0])
        r2= Coords.a_to_i( $2[1])
      else
        c1= Coords.a_to_i(str[0])
        r1= Coords.a_to_i(str[1])
        c2= nil
        r2= nil
      end
      return [c1,r1,c2,r2]
    end
  end

  class PMove < Property
    include Coords

    def print_game(game,dimx,dimy)
      puts
      for j in -1..dimy
        for i in -1..dimx
          putc game[i][j]
        end
        puts
      end
    end

    def col
      @col= a_to_i(@values[0][0]) if @col.nil?
      @col
    end

    def row
      @row= a_to_i(@values[0][1]) if @row.nil?
      @row
    end

    def move_pass
      @values[0].empty? or @values[0] == 'tt'
    end

    def have_lib(game,col,row)
      color= game[col][row]
      newcolor=(color == ?W ? ?w : ?b)
      game[col][row] = newcolor

      return true if game[col+1][row] == ?E
      return true if game[col][row+1] == ?E
      return true if game[col-1][row] == ?E
      return true if game[col][row-1] == ?E

      return true if  game[col+1][row] == color and  have_lib(game,col+1,row)
      return true if  game[col][row+1] == color and  have_lib(game,col,row+1)
      return true if  game[col-1][row] == color and  have_lib(game,col-1,row)
      return true if  game[col][row-1] == color and  have_lib(game,col,row-1)

      return false
    end
  end

  class PRoot < Property
    def size_to_i
      return unless @ident == 'SZ'
      return [ @values[0],  @values[0]] if @values[0].kind_of? Integer
      m = /(\d+):?(\d+)?/.match @values[0]
      w= m[1].to_i
      h =(m[2].nil? ? w : m[2].to_i)
      return [w,h]
    end

    def content
      @values[0]
    end
  end

  class PInfo_TO < Property
  end

  class PInfo < Property
    def title
      case @ident
      when 'AN'
        'Annotations'
      when 'BR'
        'Black rank'
      when 'BT'
        'Black team'
      when 'CP'
        'Copyright'
      when 'DT'
        'Date'
      when 'EV'
        'Event'
      when 'GN'
        'Name'
      when 'GC'
        'Comment'
      when 'ON'
        'Opening'
      when 'OT'
        'Byo-yomi'
      when 'PB'
        'Black'
      when 'PC'
        'Place'
      when 'PW'
        'White'
      when 'RE'
        'Result'
      when 'RO'
        'Round-number'
      when 'RU'
        'Rules'
      when 'SO'
        'Source'
      when 'TM'
        'Time'
      when 'US'
        'User'
      when 'WR'
        'White rank'
      when 'WT'
        'White'
      when 'ID'
        'Game Number'
      when 'HA'
        'Handicap'
      when 'KM'
        'Komi'
      end
    end

    def content
      @values[0]
    end
  end

  class PNode < Property
    def to_s
      if @ident == 'C'
        buf =  ''
        buf << @ident << '['
        @values[0].each_byte do |c| 
          buf << ?\\ if c == ?\\ or c == ?] or c== ?:
          buf << c 
        end
        buf << ']'
      else
        super
      end
    end
  end

  class PAnnot < Property
  end

  class PSetup < Property
    include Coords
  end

  class PMark < Property
    include Coords
  end

  class PGo < Property
    include Coords
  end

  class PTime < Property
    include Coords
  end

  class PPrint < Property
    include Coords
  end

  Property.class_eval do
    Klass = { 'W'=> PMove, 'B'=> PMove ,'MN'=> PMove, 'KO'=> PMove ,
      'SZ'=> PRoot, 'AP'=> PRoot , 'CA'=> PRoot , 'FF'=> PRoot , 'GM'=> PRoot , 
      'ST'=> PRoot, 'SY'=>PRoot, # SY=AP by Cgoban 1.9.2
      'AN'=> PInfo, 'BR'=> PInfo, 'BT'=> PInfo, 'CP'=> PInfo, 'DT'=> PInfo,
      'EV'=> PInfo, 'GN'=> PInfo, 'GC'=> PInfo, 'ON'=> PInfo, 'OT'=> PInfo,
      'TO'=> PInfo_TO, # private prop for OT in sgf5 -> discarded
      'PB'=> PInfo, 'PC'=> PInfo, 'PW'=> PInfo, 'RE'=> PInfo, 'RO'=> PInfo,
      'HA'=> PInfo, 'KM'=> PInfo,'ID'=> PInfo, #not documented. used for igs game number
      'RU'=> PInfo, 'SO'=> PInfo, 'TM'=> PInfo, 'US'=> PInfo, 'WR'=> PInfo, 'WT'=> PInfo,
      'BM'=> PAnnot, 'DO'=> PAnnot, 'IT'=> PAnnot, 'TE'=> PAnnot,
      'N' => PNode, 'C'=> PNode, 'V'=> PNode, 'DM'=> PNode, 'GB'=> PNode,
      'GW'=> PNode, 'HO'=> PNode, 'UC'=> PNode,
      'AB' => PSetup, 'AE' => PSetup, 'AW' => PSetup, 'PL' => PSetup ,
      'AR'=> PMark, 'CR'=> PMark, 'DD'=> PMark, 'LB'=> PMark, 'LN'=> PMark,
      'MA'=> PMark, 'SL'=> PMark, 'SQ'=> PMark, 'TR' => PMark,
      'M'=> PMark, 'L' => PMark, # old sgf format Mark and Letters
      'TB'=> PGo, 'TW'=> PGo, 'DA'=> PGo, # new: Dame
      'WP'=> PGo, 'BP'=> PGo, # not standard: prisoners -> discarded
      'BL'=> PTime, 'OB'=> PTime, 'OW'=> PTime, 'WL'=> PTime,
      'VW'=> PPrint, 'PM'=> PPrint, 'FG'=> PPrint ,
      'NW'=>PUnknown,'NB'=>PUnknown,'LT'=>PUnknown,
      'PT'=>PUnknown,'RN'=>PUnknown,'RD'=>PUnknown,
      'LC'=>PUnknown
    }

    def self.create(ident)
      klass = Klass[ident]
      if klass.nil?
        $stderr.puts "unknown property #{ident}"
        klass = PUnknown
      end
      klass.new(ident)
    end
  end
end