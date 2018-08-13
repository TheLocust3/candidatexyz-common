$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "candidatexyz/common/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "candidatexyz-common"
  s.version     = CandidateXYZ::Common::VERSION
  s.authors     = ["TheLocust3"]
  s.email       = ["jake.kinsella@gmail.com"]
  s.homepage    = "https://github.com/TheLocust3/candidatexyz-common"
  s.summary     = "candidateXYZ common libraries."
  s.description = "candidateXYZ common libraries."
  s.license     = "NONE"

  s.files = Dir["{app,config,db,lib}/**/*", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.1.4"
  s.add_dependency "httparty"
  s.add_dependency "minitest-reporters"
end
