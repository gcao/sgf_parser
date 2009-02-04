require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

module SGF
  module Model
    describe EventListener do
      before :each do
        @listener = EventListener.new
      end
      
      it "should have game" do
        @listener.game.should_not be_nil
      end
      
      it "should start a new game on start_game" do
        @listener.start_game
        game1 = @listener.game
        @listener.start_game
        game2 = @listener.game
        game1.should_not == game2
      end
      
      it "set_property('GN', 'a game') should set game name" do
        @listener.set_property('GN', 'a game')
        @listener.game.name.should == 'a game'
      end
    end
  end
end
