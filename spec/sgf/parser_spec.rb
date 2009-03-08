require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module SGF
  describe Parser, 'with DefaultEventListener' do
    before :each do
      @listener = DefaultEventListener.new
      @parser = Parser.new @listener
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
    
    it "should call start_node" do
      mock(@listener).start_node
      @parser.parse("(;")
    end
    
    it "should call end_game" do
      mock(@listener).end_game
      @parser.parse("(;)")
    end
    
    it "should call set_property with name and value" do
      mock(@listener).set_property('GN', 'a game')
      @parser.parse("(;GN[a game])")
    end
    
    it "should call set_property with same name and different values" do
      mock(@listener).set_property('AB', 'DB')
      mock(@listener).set_property('AB', 'KS')
      @parser.parse("(;AB[DB][KS])")
    end
    
    it "should call start_variation" do
      mock(@listener).start_variation
      @parser.parse("(;(")
    end
    
    it "should call end_variation" do
      mock(@listener).end_variation
      @parser.parse("(;(;))")
    end
  end
  
  describe Parser, 'with SGF::Model::EventListener' do
    before :each do
      @listener = SGF::Model::EventListener.new
      @parser = Parser.new @listener
    end
    
    it "should set game name" do
      @parser.parse <<-INPUT
      (;GM[1]FF[3]
      RU[Japanese]SZ[19]HA[0]KM[5.5]
      PW[White]
      PB[Black]
      GN[White (W) vs. Black (B)]
      DT[1999-07-28]
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
      @listener.game.name.should == 'White (W) vs. Black (B)'
      @listener.game.rule.should == 'Japanese'
      @listener.game.board_size.should == 19
      @listener.game.handicap.should == 0
      @listener.game.komi.should == 5.5
      @listener.game.white_player.should == 'White'
      @listener.game.black_player.should == 'Black'
    end
  end
end