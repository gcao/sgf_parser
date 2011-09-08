module SGF
  module Debugger
    def debug message = nil
      return unless @debug_mode

      puts message if message
      puts yield if block_given?
    end
  end
end