# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{sgf_parser}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Guoliang Cao"]
  s.autorequire = %q{sgf_parser}
  s.date = %q{2011-10-12}
  s.description = %q{A SGF parser gem}
  s.email = %q{cao@daoqigame.com}
  s.extra_rdoc_files = ["README.textile", "LICENSE", "TODO"]
  s.files = ["README.textile", "Rakefile", "LICENSE", "TODO", "lib/sgf", "lib/sgf/constants.rb", "lib/sgf/debugger.rb", "lib/sgf/default_event_listener.rb", "lib/sgf/event_listener.rb", "lib/sgf/game.rb", "lib/sgf/label.rb", "lib/sgf/more", "lib/sgf/more/state_machine_presenter.rb", "lib/sgf/more/stm_dot_converter.rb", "lib/sgf/node.rb", "lib/sgf/parse_error.rb", "lib/sgf/parser.rb", "lib/sgf/renderer.rb", "lib/sgf/sgf_helper.rb", "lib/sgf/sgf_state_machine.rb", "lib/sgf/state_machine.rb", "lib/sgf/variation.rb", "lib/sgf.rb", "spec/fixtures", "spec/fixtures/2009-11-01-1.sgf", "spec/fixtures/2009-11-01-2.sgf", "spec/fixtures/chinese_gb.sgf", "spec/fixtures/chinese_utf.sgf", "spec/fixtures/example.sgf", "spec/fixtures/good.json", "spec/fixtures/good.sgf", "spec/fixtures/good1.sgf", "spec/fixtures/kgs.sgf", "spec/fixtures/test.png", "spec/sgf", "spec/sgf/more", "spec/sgf/more/state_machine_presenter_spec.rb", "spec/sgf/parse_error_spec.rb", "spec/sgf/parser_spec.rb", "spec/sgf/sgf_helper_spec.rb", "spec/sgf/sgf_state_machine_spec.rb", "spec/sgf/state_machine_spec.rb", "spec/spec.opts", "spec/spec_helper.rb"]
  s.homepage = %q{http://gcao.github.com}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.4.2}
  s.summary = %q{A SGF parser gem}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
