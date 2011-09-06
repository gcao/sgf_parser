module SGF
  class Game < Variation

    def initialize
      super nil
    end

    def root_node
      @nodes.first
    end

  end
end
