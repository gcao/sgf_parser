require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require File.expand_path(File.dirname(__FILE__) + '/../../lib/sgf/parser')

module SGF
  describe Parser do
    before :each do
      @parser = Parser.new
    end
    
    it "should parse a String into a game" do
      s = "(;GM[1])"
      game = @parser.parse(s)
    end
  end
end