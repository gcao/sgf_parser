require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module SGF
  describe SGFHelper do
    before :each do
      @helper = Object.new.extend(SGFHelper)
    end
    
    describe "position_to_array" do
      
      it "should throw ArgumentError on bad argument" do
        [nil, "", "  ", "A", "ABC"].each do |bad_argument|
          lambda { @helper.position_to_array(bad_argument) }.should raise_error(ArgumentError)
        end
      end

      it "should convert AB to [0, 1]" do
        @helper.position_to_array("AB").should == [0, 1]
      end

      it "should not be case sensitive" do
        @helper.position_to_array("ab").should == [0, 1]
        @helper.position_to_array("aB").should == [0, 1]
        @helper.position_to_array("Ab").should == [0, 1]
        @helper.position_to_array("AB").should == [0, 1]
      end
      
      it "should ignore leading and trailing spaces" do
        @helper.position_to_array(" AB").should == [0, 1]
        @helper.position_to_array("AB ").should == [0, 1]
        @helper.position_to_array(" AB ").should == [0, 1]
      end
        
    end
    
    describe "string_to_label" do
      it "should return label" do
        @helper.string_to_label("AB:C").should == SGF::Model::Label.new(@helper.position_to_array("AB"), "C")
      end
    end
  end
end