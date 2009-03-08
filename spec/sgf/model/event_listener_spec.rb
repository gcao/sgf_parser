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
          mock(@listener.game).send(attr_name, '123')
          @listener.set_property(prop_name, ' 123 ')
        end
      end

      it "should create a node on start_node" do
        @listener.start_node
        @listener.game.nodes.size.should == 1
      end
      
      it "set_property('C', ...) should add comment to node" do
        @listener.start_node
        @listener.set_property('C', 'comment')
        @listener.game.root_node.comment.should == 'comment'
      end
      
    end
  end
end
