module SGF
  module SGFHelper
    def position_to_array position
      raise ArgumentError.new(position) if position.nil? or position.strip.length != 2

      s = position.strip.downcase
      [s[0] - ?a, s[1] - ?a]
    end
    
    def string_to_label input
      raise ArgumentError.new(input) if input.nil? or not input.include?(':')
      
      position, text = input.split(':')
      SGF::Model::Label.new(position_to_array(position), text.strip)
    end
  end
end