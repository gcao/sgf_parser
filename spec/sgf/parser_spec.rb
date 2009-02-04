require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module SGF
  describe Parser do
    before :each do
      @listener = EventListener.new
      @parser = Parser.new @listener
    end

    {'nil' => nil, '' => '', '  ' => '  '}.each do |name, value|
      it "should throw error on bad input - '#{name}'" do
        begin
          @parser.parse(value)
          fail("Should raise error")
        rescue => e
          e.class.should == ArgumentError
        end
      end
    end
    
    it "should call start_game" do
      mock(@listener).start_game
      @parser.parse("(")
    end
    
    it "should call start_node" do
      mock(@listener).start_node
      @parser.parse("(;")
    end
    
    it "should call end_game" do
      mock(@listener).end_game
      @parser.parse("(;)")
    end
    
    it "should call set_property with name and value" do
      mock(@listener).set_property('GN', 'a game')
      @parser.parse("(;GN[a game])")
    end
    
    it "should call start_variation" do
      mock(@listener).start_variation
      @parser.parse("(;(")
    end
    
    it "should call end_variation" do
      mock(@listener).end_variation
      @parser.parse("(;(;))")
    end
  end
end