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
      
      it "start_variation should create a new variation" do
        pending "INCOMPLETE"
        @listener.start_game
        @listener.start_node
        node = @listener.node
        @listener.start_variation
        @listener.variations.should == [node]
      end
      
      EventListener::GAME_PROPERTY_MAPPINGS.each do |prop_name, attr_name|
        it "call property_name=#{prop_name} and property_value=something should set #{attr_name} on game" do
          mock(@listener.game).send(attr_name, '123')
          @listener.property_name = prop_name
          @listener.property_value = '123'
        end
      end

      it "should create a node on start_node" do
        @listener.start_node
        @listener.game.nodes.size.should == 1
      end
      
      it "property_name='C' and property_value=something should add comment to node" do
        @listener.start_node
        @listener.property_name = "C"
        @listener.property_value = "comment"
        @listener.game.root_node.comment.should == 'comment'
      end
      
    end
  end
end
