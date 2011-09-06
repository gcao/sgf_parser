module SGF
  class Node

    def properties
      @properties ||= {}
    end
    
    def variations
      @variations ||= []
    end
    
    def [] name
      properties[name.to_s.strip.upcase]
    end

    def empty?
      @properties.nil? or @properties.empty?
    end
    
    def add_property name, value
      return if name.nil? or value.nil?
      
      name.strip!
      name.upcase!
      value.strip!
      
      return if name.empty? or value.empty?
      
      found = properties[name]
      
      if found.nil?
        properties[name] = value
      elsif found.is_a? Array
        found << value
      else
        properties[name] = [found, value]
      end
    end

  end
end
