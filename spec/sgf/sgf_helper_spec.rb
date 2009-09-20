require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module SGF
  describe SGFHelper do
    before :each do
      @helper = Object.new.extend(SGFHelper)
    end
    
    describe "to_position_array" do
      
      [nil, "", "  ", "A", "ABC"].each do |bad_argument|
        it "should throw ArgumentError on bad argument(#{bad_argument.inspect})" do
          lambda { @helper.to_position_array(bad_argument) }.should raise_error(ArgumentError)
        end
      end

      it "should convert AB to [[0, 1]]" do
        @helper.to_position_array("AB").should == [[0, 1]]
      end

      it "should be case insensitive" do
        @helper.to_position_array("ab").should == [[0, 1]]
        @helper.to_position_array("aB").should == [[0, 1]]
        @helper.to_position_array("Ab").should == [[0, 1]]
        @helper.to_position_array("AB").should == [[0, 1]]
      end
      
      it "should ignore leading and trailing spaces" do
        @helper.to_position_array(" AB").should == [[0, 1]]
        @helper.to_position_array("AB ").should == [[0, 1]]
        @helper.to_position_array(" AB ").should == [[0, 1]]
      end
      
      it "should convert AB:BC to [[0,1], [0,2], [1,1], [1,2]]" do
        @helper.to_position_array("AB:BC").should == [[0,1], [0,2], [1,1], [1,2]]
      end
        
    end
    
    describe "to_position" do
      it "should convert AB to [0, 1]" do
        @helper.to_position("AB").should == [0, 1]
      end

      it "should be case insensitive" do
        @helper.to_position("ab").should == [0, 1]
      end
    end
    
    describe "to_label" do
      it "should return label" do
        @helper.to_label("AB:C").should == SGF::Model::Label.new(@helper.to_position("AB"), "C")
      end
    end
  end
end