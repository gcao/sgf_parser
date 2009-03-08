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

      it "should convert AA to [1, 1]" do
        @helper.position_to_array("AB").should == [0, 1]
      end
    end
  end
end