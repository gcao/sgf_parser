begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "sgf_parser"
    gem.summary = %Q{A SGF parser}
    gem.description = %Q{A simple SGF parser}
    gem.email = "gcao99@gmail.com"
    gem.homepage = "http://github.com/gcao/discuz_robot"
    gem.authors = ["Guoliang Cao"]
    gem.add_development_dependency "rspec", "~> 1.3.0"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

desc "visualize SGF state machine"
task :vst do
  system("bin/stm2dot && dot -T svg -o doc/sgf_state_machine.svg doc/sgf_state_machine.dot")
end
