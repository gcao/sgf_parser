module SGF
  module SGFHelper
    def to_position_array input
      raise ArgumentError.new(input) if input.nil? or input.strip.length != 2

      s = input.strip.downcase
      [s[0] - ?a, s[1] - ?a]
    end
    
    def to_label input
      raise ArgumentError.new(input) if input.nil? or not input.include?(':')
      
      position, text = input.split(':')
      SGF::Model::Label.new(to_position_array(position), text.strip)
    end
  end
end