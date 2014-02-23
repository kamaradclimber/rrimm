Gem::Specification.new do |s|
  s.name        = 'rrimm'
  s.version     = '0.1.0'
  s.licenses    = ['Apache Licence v2']
  s.summary     = "RSS to email tool"
  s.description = "imm reboot in ruby. Retrieve rss feeds and send them by email"
  s.authors     = ["Grégoire Seux"]
  s.email       = 'rrimm@familleseux.net'
  s.homepage    = "http://github.com/kamaradclimber/mosespa"
  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- spec/*`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }

  s.add_development_dependency 'rspec'
end
