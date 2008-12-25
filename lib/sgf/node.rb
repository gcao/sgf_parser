module SGF
  class Node  
  	attr_accessor :prev, :next, :var_next, :var_prev, :c_var, :props
  	attr_accessor :move_nb, :w_pris, :b_pris

  	def initialize
  		@props = Hash.new
  	end

  	def to_s
  		str = ';'
  		str << @prop_MN.to_s if @prop_MN
  		each_value { |prop| str << prop.to_s }
  		str << "\n"
  	end

  	def [] (key)
  		case key
  		when 'MN'
  			return @prop_MN
  		when 'SZ'
  			if @props['SZ'].nil?
  				return [19, 19]
  			else
  				return @props['SZ'].size_to_i
  			end
  		when 'ST', 'HA'
  			if @props[key].nil?
  				return 0
  			else
  				return @props[key].to_i
  			end
  		when 'KM'
  			if @props['KM'].nil?
  				return 0.0
  			else
  				return @props['KM'].values[0].to_f
  			end
  		else
  			return @props[key]
  		end
  	end

  	def get_prop(key)
  		@props[key]
  	end

  	def has_key?(key)
  		case key
  		when 'MN'
  			return @prop_MN
  		else
  			return @props.has_key?(key)
  		end
  	end

  	def []= (key, value = '')
  		if key == 'MN'
  			@prop_MN = Property.create(key) if @prop_MN.nil?
  			@prop_MN.set_node(self)
  			@prop_MN.push(value) 
  		else
  			store(key,Property.create(key)) unless @props.key?(key)
  			@props[key].push(value) 
  		end
  	end

  	def add_comment(value)
      #must be only one value in Comment property
  		store('C',Property.create('C')) unless @props.key?('C')
  		p = @props['C']
  		if p.values[0]
  			p.values[0] += value
  		else
  			p.push(value)
  		end
  	end

  	def action(gowin, key = nil)
  		if key
  			if key == 'MN'
  				@prop_MN.action(gowin) 
  			else
  				@props[key].action(gowin)
  			end
  		else
  			@prop_MN.action(gowin) if @prop_MN
  			@props.each_value { | prop| prop.action(gowin) }
  		end
  	end

  	def each_value
  		@props.each_value { | val| yield(val) }
  	end

  	def store(key, prop)
  		prop.set_node(self)
  		@props.store(key,prop)
  	end

  	def delete(key)
  		@props.delete(key)
  	end

  	def set(key,val)
  		if @props.key?(key)
  			@props[key].values[0] = val
  		else
  			self[key] = val
  		end
  	end

  	def empty?
  		@props.empty?
  	end 

  	def push(prop)
  		# for Kogo
  		# no problem with that
  		#    if  (prop.ident== 'AB' or prop.ident=='AW' or prop.ident=='AW') and (has_key?('W') or has_key?('B'))
  		#      $stderr.puts ("warning: move and setup mixed in the same node")
  		#     end
  		if prop.ident == 'AE'
  			for p in [@props['AB'],  @props['AW']]
  				if p
  					list = prop.values.clone
  					list.each do |v|
  						if p.values.include?(v)
  							p.values.delete(v)
  							prop.values.delete(v)
  						end 
  					end
  					if p.values.empty? 
  						@props.delete(p.ident)
  						$stderr.puts("Illegal properties AE and #{p.ident} with identical values #{list.inspect} - deleted")
  					end
  				end
  			end
  		end

  		#for cgoban
  		if prop.ident == 'CR'
  			for p in [@props['B'], @props['W']]
  				if p and p.values[0] == prop.values[0]
  					return
  				end
  			end
  		end

  		# for gifus
  		if @props.has_key?(prop.ident)
  			p = @props[prop.ident]
  			if prop.ident == 'C'
  				prop.values.each {  |v|  p.values[0] << "\n"<< v}
  			else
  				prop.values.each { |v| p.push(v) }
  			end
  			return
  		end

  		store(prop.ident,prop) unless prop.values.empty?
  	end

  	def merge(node)
  		node.props.each{|k,v| self[k]=v }
  	end
  end
end