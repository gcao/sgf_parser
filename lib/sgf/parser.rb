module SGF
  class Parser    
    attr_reader :event_listener
    
    def initialize event_listener
      @event_listener = event_listener
      @stm = SGFStateMachine.new event_listener
    end
    
    def parse input
      raise ArgumentError.new if input.nil? or input.strip.empty?
      
      input.strip!
        
      0.upto(input.size - 1) do |i|
        @position = i
        @stm.event(input[i,1])
      end
      
      @stm.end
    rescue SGF::ParseError => e
      puts e
      raise format_error input, @position, e
    end
    
    def parse_file filename
      File.open(filename) do |f|
        parse f.readlines.join
      end
    end
    
    class << self
      def parse input, debug = false
        parser = SGF::Parser.new(SGF::Model::EventListener.new(debug))
        parser.parse input
        parser.event_listener.game
      end
    
      def parse_file filename, debug = false
        parser = SGF::Parser.new(SGF::Model::EventListener.new(debug))
        parser.parse_file filename
        parser.event_listener.game
      end
    end
    
    private
    
    def format_error input, position, e
      if position > 1000
        start_position = position - 1000
        s = '"...'
      else
        start_position = 0
        s = '"'
      end
      s << input[start_position..position]
      s << '" <==='
      s << e.message
      raise s
    end
  end
end