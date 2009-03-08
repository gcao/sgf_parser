module SGF
  module Model
    module PositionHelper
      def position_to_array position
        raise ArgumentError.new(position) if position.nil? or position.strip.length != 2
      end
    end
  end
end