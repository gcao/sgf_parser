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

    def to_hash
      hash_obj = {:type => 'Variation'}
      hash_obj[:children] = children.map do |node|
        node.to_hash
      end
      hash_obj
    end

  end
end
