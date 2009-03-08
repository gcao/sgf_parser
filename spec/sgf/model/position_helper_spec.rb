require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

module SGF
  module Model
    describe PositionHelper do
      before :each do
        @helper = Object.new.extend(PositionHelper)
      end
      
      it "position_to_array should convert AA to [1, 1]" do
        @helper.position_to_array("AA").should == [1, 1]
      end
    end
  end
end