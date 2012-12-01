# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "music-pdf-view/version"

Gem::Specification.new do |s|
  s.name        = "music-pdf-view"
  s.version     = Music::Pdf::View::VERSION
  s.authors     = ["Geoff Youngs"]
  s.email       = ["git@intersect-uk.co.uk"]
  s.homepage    = ""
  s.summary     = %q{Display sheet music PDFs in a single pane}
  s.description = %q{A super simple PDF viewer for files from Kingsway Music (and other sites) who offer songs in 3 & 4 page documents which don't display well on a computer screen.}

  s.rubyforge_project = "music-pdf-view"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  s.add_runtime_dependency "gtk2"
  s.add_runtime_dependency "poppler"
  s.add_runtime_dependency "json"
end
