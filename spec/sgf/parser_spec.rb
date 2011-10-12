require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module SGF
  describe Parser, 'with DefaultEventListener' do
    before :each do
      @listener = DefaultEventListener.new
      @parser   = Parser.new @listener
    end

    {'nil' => nil, '' => '', '  ' => '  '}.each do |name, value|
      it "should throw error on bad input - '#{name}'" do
        begin
          @parser.parse(value)
          fail("Should raise error")
        rescue => e
          e.class.should == ArgumentError
        end
      end
    end

    it "should call start_game" do
      mock(@listener).start_game
      @parser.parse("(")
    end

    it "should call end_game" do
      mock(@listener).end_game
      @parser.parse("(;)")
    end

    it "should call start_node" do
      mock(@listener).start_node
      @parser.parse("(;")
    end

    it "should call end_variation" do
      mock(@listener).end_variation
      @parser.parse("(;)")
    end

    it "should call property_name= with name" do
      mock(@listener).property_name = 'GN'
      @parser.parse("(;GN[)")
    end

    it "should call property_value= with value" do
      mock(@listener).property_value = 'a game'
      @parser.parse("(;GN[a game])")
    end

    it "should call property_value= for each value" do
      mock(@listener).property_value = 'DB'
      mock(@listener).property_value = 'KS'
      @parser.parse("(;AB[DB][KS])")
    end

    it "should call start_variation" do
      mock(@listener).start_variation
      @parser.parse("(;(")
    end

    it "should call end_variation" do
      mock(@listener).end_variation
      @parser.parse("(;(;)")
    end
  end

  describe Parser, 'with SGF::EventListener' do
    before :each do
      @listener = SGF::EventListener.new
      @parser   = Parser.new @listener
    end

    it "should parse game in file" do
      @parser.parse_file File.expand_path(File.dirname(__FILE__) + '/../fixtures/good.sgf')
      game = @listener.game
      game['GN'].should == 'White (W) vs. Black (B)'
      game['RU'].should == 'Japanese'
      game['SZ'].should == '19'
    end

    it "should parse game without moves" do
      @parser.parse <<-INPUT
      (;GM[1]FF[3]
      GN[White (W) vs. Black (B)];
      )
      INPUT
      game = @listener.game
      game['GN'].should == 'White (W) vs. Black (B)'
    end

    it "should raise error on invalid input" do
      lambda { @parser.parse("123") }.should raise_error
    end

    it "should parse a complete game" do
      @parser.parse <<-INPUT
      (;GM[1]FF[3]
      RU[Japanese]SZ[19]HA[0]KM[5.5]
      PW[White]
      PB[Black]
      GN[White (W) vs. Black (B)]
      DT[1999-07-28]
      RE[W+R]
      SY[Cgoban 1.9.2]TM[30:00(5x1:00)];
      AW[ea][eb][ec][bd][dd][ae][ce][de][cf][ef][cg][dg][eh][ci][di][bj][ej]
      AB[da][db][cc][dc][cd][be][bf][ag][bg][bh][ch][dh]LB[bd:A]PL[2]
      C[guff plays A and adum tenukis to fill a 1-point ko. white to kill.
      ]
      (;W[bc];B[bb]
      (;W[ca];B[cb]
      (;W[ab];B[ba]
      (;W[bi]
      C[RIGHT black can't push (but no such luck in the actual game)
      ])
      )))
      )
      INPUT
      game = @listener.game

      game['GM'].should == '1'
      game['FF'].should == '3'
      game['RU'].should == 'Japanese'
      game['SZ'].should == '19'
      game['HA'].should == '0'
      game['KM'].should == '5.5'
      game['PW'].should == 'White'

      game.children[1]['AW'].should == %w(ea eb ec bd dd ae ce de cf ef cg dg eh ci di bj ej)
      game.children[1]['C'].should == "guff plays A and adum tenukis to fill a 1-point ko. white to kill."

      node = game.children[1]
      node.variations.size.should == 1
      node.variations.first.children.first['W'].should == 'bc'
    end
  end

  describe "class methods" do
    it "parse should take a String and parse it and return the game" do
      game = SGF::Parser.parse <<-INPUT
      (;GM[1]FF[3]
      GN[White (W) vs. Black (B)];
      )
      INPUT
      game['GN'].should == 'White (W) vs. Black (B)'
    end

    it "parse should pass debug parameter to event listener" do
      event_listener = SGF::EventListener.new(false)
      mock(SGF::EventListener).new(true) {event_listener}
      SGF::Parser.parse "(;GM[1])", true
    end

    it "parse_file should take a sgf file and parse it and return the game" do
      game = SGF::Parser.parse_file File.expand_path(File.dirname(__FILE__) + '/../fixtures/good.sgf')
      game['GN'].should == 'White (W) vs. Black (B)'
    end

    it "parse_file should pass debug parameter to event listener" do
      event_listener = SGF::EventListener.new(false)
      mock(SGF::EventListener).new(true) {event_listener}
      game = SGF::Parser.parse_file(File.expand_path(File.dirname(__FILE__) + '/../fixtures/good.sgf'), true)
      game['GN'].should == 'White (W) vs. Black (B)'
    end

    it "should parse game with escaped []" do
      game = SGF::Parser.parse_file(File.expand_path(File.dirname(__FILE__) + '/../fixtures/good1.sgf'))
    end
  end
end
