module SGF
  module SGFHelper
    def to_position_array input
      raise ArgumentError.new(input) if input.nil? or input !~ /^\s*\w\w(:\w\w)?\s*$/

      input.strip!
      input.downcase!
      
      if input.include?(':')
        parts = input.split(':', 2)
        position1 = to_position(parts[0])
        position2 = to_position(parts[1])
        positions = []
        (position1[0]..position2[0]).each do |i|
          (position1[1]..position2[1]).each do |j|
            positions << [i, j]
          end
        end
        positions
      else
        [to_position(input)]
      end
    end
    
    def to_position input
      raise ArgumentError.new(input) if input.nil? or input.strip.length != 2
      
      input.strip!
      input.downcase!
      
      [input[0] - ?a, input[1] - ?a]
    end
    
    def to_label input
      raise ArgumentError.new(input) if input.nil? or input !~ /^\s*\w\w:\w+\s*$/
      
      position, text = input.split(':', 2)
      SGF::Model::Label.new(to_position(position), text.strip)
    end
  end
end