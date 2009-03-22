require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

module SGF
  module Model
    describe Node do
      it "sgf_setup_black should add an entry to black_moves" do
        node = Node.new
        node.sgf_setup_black "AB"
        node.black_moves.first.should == [0, 1]
      end
      
      it "sgf_setup_white should add an entry to white_moves" do
        node = Node.new
        node.sgf_setup_white "AB"
        node.white_moves.first.should == [0, 1]
      end
      
      it "sgf_play_black should set node type to MOVE and save move information" do
        node = Node.new
        node.sgf_play_black "AB"
        node.node_type.should == Constants::NODE_MOVE
        node.color.should == Constants::BLACK
        node.move.should == [0, 1]
      end
      
      it "sgf_play_white should set node type to MOVE and save move information" do
        node = Node.new
        node.sgf_play_white "AB"
        node.node_type.should == Constants::NODE_MOVE
        node.color.should == Constants::WHITE
        node.move.should == [0, 1]
      end
      
      it "child returns first child" do
        node = Node.new
        first_child = Node.new(node)
        second_child = Node.new(node)
        node.child.should == first_child
      end
    end
  end
end