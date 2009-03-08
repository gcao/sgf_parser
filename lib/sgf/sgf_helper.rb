module SGF
  module SGFHelper
    def position_to_array position
      raise ArgumentError.new(position) if position.nil? or position.strip.length != 2

      s = position.strip.downcase
      [s[0] - ?a, s[1] - ?a]
    end
  end
end