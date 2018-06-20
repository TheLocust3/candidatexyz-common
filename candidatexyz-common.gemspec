$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "candidatexyz/common/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "candidatexyz-common"
  s.version     = Candidatexyz::Common::VERSION
  s.authors     = ["TheLocust3"]
  s.email       = ["jake.kinsella@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Candidatexyz::Common."
  s.description = "TODO: Description of Candidatexyz::Common."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.1.6"
  s.add_dependency "httparty"

  s.add_development_dependency "sqlite3"
end
