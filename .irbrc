Dir["#{File.expand_path(File.dirname(__FILE__))}/lib/**/*.rb"].each do |rb_files|
  require rb_files
end