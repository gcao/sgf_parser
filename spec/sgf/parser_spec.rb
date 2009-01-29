require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require File.expand_path(File.dirname(__FILE__) + '/../../lib/sgf/parser')
require File.expand_path(File.dirname(__FILE__) + '/../../lib/sgf/event_listener')

module SGF
  describe Parser do
    before :each do
      @listener = EventListener.new
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
    
    it "should read game name" do
      mock(@listener).set_game_name('a game')
      @parser.parse("(;GN[a game])")
    end
  end
end