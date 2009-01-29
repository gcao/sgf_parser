require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require File.expand_path(File.dirname(__FILE__) + '/../../lib/sgf/parser')

module SGF
  describe Parser do
    before :each do
      @parser = Parser.new
    end
    
    it "should parse a String into a game" do
      s = "(;)"
      game = @parser.parse(s)
      game.size.should == 1
    end
    
    describe "Root properties" do
      before :each do 
        input = "(;GM[1]FF[3]
                   RU[Japanese]SZ[19]HA[0]KM[5.5]
                   PW[White]PB[Black]
                   GN[White (W) vs. Black (B)]
                   DT[1999-07-28]
                   SY[Cgoban 1.9.2]TM[30:00(5x1:00)])"
        game = @parser.parse(input)
        @root = game.first
      end
      
      { 'GM' => '1', 'FF' => 3, 'RU' => 'Japanese', 'HA' => 0,
        'PW' => 'White', 'PB' => 'Black', 'GN' => 'White (W) vs. Black (B)',
        'DT' => '1999-07-28', 'SY' => 'Cgoban 1.9.2', 'TM' => '30:00(5x1:00)'
      }.each do |key, value|
        it key do
          @root[key].should_not be_nil
          @root[key].values[0].to_s.should == value.to_s
        end
      end
      
      it 'SZ' do
        @root['SZ'].should_not be_nil
        @root['SZ'].should == [19, 19]
      end
      
      it 'KM' do
        @root['KM'].should_not be_nil
        @root['KM'].should == 5.5
      end
        
    end
  end
end