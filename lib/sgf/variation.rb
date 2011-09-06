module SGF
  class Variation < Array

    attr :parent
    attr :nodes

    def initialize parent
      @parent = parent
      @nodes = []
    end

  end
end
