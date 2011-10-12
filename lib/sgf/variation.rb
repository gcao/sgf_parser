module SGF
  class Variation

    attr :parent
    attr :children

    def initialize parent
      @parent = parent

      parent.variations << self if parent

      @children = []
    end

    def cleanup
      @children.each do |child|
        child.cleanup
      end
    end

  end
end
