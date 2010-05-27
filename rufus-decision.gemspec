# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rufus-decision}
  s.version = "1.3.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["John Mettraux"]
  s.date = %q{2010-05-28}
  s.default_executable = %q{rufus_decide}
  s.description = %q{
CSV based Ruby decision tables
  }
  s.email = %q{jmettraux@gmail.com}
  s.executables = ["rufus_decide"]
  s.extra_rdoc_files = [
    "LICENSE.txt",
     "README.rdoc"
  ]
  s.files = [
    "CHANGELOG.txt",
     "CREDITS.txt",
     "LICENSE.txt",
     "README.rdoc",
     "Rakefile",
     "TODO.txt",
     "bin/rufus_decide",
     "demo/README.txt",
     "demo/public/decision.html",
     "demo/public/decision.js",
     "demo/public/images/arrow.png",
     "demo/public/images/ruse_head_bg.png",
     "demo/public/in.js",
     "demo/public/js/request.js",
     "demo/public/js/ruote-sheets.js",
     "demo/start.rb",
     "examples/journalists.rb",
     "examples/readme_example.rb",
     "examples/reimbursement.csv",
     "examples/reimbursement.rb",
     "examples/reimbursement2.csv",
     "lib/rufus-decision.rb",
     "lib/rufus/decision.rb",
     "lib/rufus/decision/hashes.rb",
     "lib/rufus/decision/participant.rb",
     "lib/rufus/decision/table.rb",
     "lib/rufus/decision/version.rb",
     "rufus-decision.gemspec",
     "test/base.rb",
     "test/dt_0_basic.rb",
     "test/dt_1_vertical.rb",
     "test/dt_2_google.rb",
     "test/dt_3_bounded.rb",
     "test/dt_4_eval.rb",
     "test/dt_5_transpose.rb",
     "test/goal.csv",
     "test/input.csv",
     "test/ruote/base.rb",
     "test/ruote/rt_0_basic.rb",
     "test/ruote/test.rb",
     "test/table.csv",
     "test/test.rb"
  ]
  s.homepage = %q{http://github.com/jmettraux/rufus-decision/}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{rufus}
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{CSV based Ruby decision tables}
  s.test_files = [
    "test/test.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rufus-dollar>, [">= 0"])
      s.add_runtime_dependency(%q<rufus-treechecker>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<yard>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, [">= 0"])
    else
      s.add_dependency(%q<rufus-dollar>, [">= 0"])
      s.add_dependency(%q<rufus-treechecker>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<yard>, [">= 0"])
      s.add_dependency(%q<jeweler>, [">= 0"])
    end
  else
    s.add_dependency(%q<rufus-dollar>, [">= 0"])
    s.add_dependency(%q<rufus-treechecker>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<yard>, [">= 0"])
    s.add_dependency(%q<jeweler>, [">= 0"])
  end
end

