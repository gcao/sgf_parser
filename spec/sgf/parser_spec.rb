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
      @parser.parse("(;(;))")
    end
  end
  
  describe Parser, 'with SGF::Model::EventListener' do
    before :each do
      @listener = SGF::Model::EventListener.new
      @parser   = Parser.new @listener
    end
    
    it "should parse a complete game" do
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
      game = @listener.game
      game.name.should == 'White (W) vs. Black (B)'
      game.rule.should == 'Japanese'
      game.board_size.should == 19
      game.handicap.should == 0
      game.komi.should == 5.5
      game.played_on.should == "1999-07-28"
      game.white_player.should == 'White'
      game.black_player.should == 'Black'
      game.application.should == 'Cgoban 1.9.2'
      game.time_rule.should == '30:00(5x1:00)'
      
      game.root_node.node_type.should == SGF::Model::Constants::NODE_SETUP
      
      game.nodes[1].node_type.should == SGF::Model::Constants::NODE_SETUP
      game.nodes[1].comment.should == "guff plays A and adum tenukis to fill a 1-point ko. white to kill."
      game.nodes[1].black_moves.should include([3, 0])
      game.nodes[1].black_moves.should include([3, 1])
      game.nodes[1].white_moves.should include([4, 0])
      game.nodes[1].white_moves.should include([4, 1])
      game.nodes[1].labels[0].should == SGF::Model::Label.new([1, 3], "A")
      
      game.nodes[2].node_type.should == SGF::Model::Constants::NODE_MOVE
      game.nodes[2].color.should == SGF::Model::Constants::WHITE
      game.nodes[2].move.should == [1, 2]
      
      game.nodes[3].node_type.should == SGF::Model::Constants::NODE_MOVE
      game.nodes[3].color.should == SGF::Model::Constants::BLACK
      game.nodes[3].move.should == [1, 1]
    end
  end
end