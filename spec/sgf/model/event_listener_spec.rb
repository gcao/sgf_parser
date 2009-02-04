require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

module SGF
  module Model
    describe EventListener do
      before :each do
        @listener = EventListener.new
      end
      
      (DefaultEventListener.instance_methods - DefaultEventListener.superclass.instance_methods).each do |method|
        it "should implement #{method} from SGF::DefaultEventListener" do
          @listener.methods.should include(method)
        end
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
      
      EventListener::GAME_PROPERTY_MAPPINGS.each do |prop_name, attr_name|
        it "set_property with property name as #{prop_name} should set #{attr_name} on game" do
          @listener.set_property(prop_name, '123')
          
          game_attr_value = @listener.game.send(attr_name.to_sym)
          if [Fixnum, Float].include?(game_attr_value.class)
            game_attr_value.should == 123
          else
            game_attr_value.should == '123'
          end
        end
      end
      
    end
  end
end
