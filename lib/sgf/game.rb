module SGF
  class Game < Variation

    def initialize
      super nil
    end

    def root_node
      @children.first
    end

    def properties
      root_node.properties
    end

    def [] name
      root_node[name]
    end

    def cleanup
      raise "Not a valid game" unless root_node

      @children.each do |child|
        child.cleanup
      end
    end

  end
end
