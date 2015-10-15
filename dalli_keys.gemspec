Gem::Specification.new do |s|
  s.name        = 'dallikeys'
  s.version     = '0.0.2'
  s.date        = '2015-08-14'
  s.summary     = 'DalliKeys'
  s.description = 'DalliKeys extends Dalli with tools to get key information'
  s.authors     = ['Thomas Hart']
  s.email       = 'tom@thomashart.me'
  s.files       = ['lib/dalli_keys.rb', 'lib/dalli_keys/dalli_key.rb']
  s.homepage    = 'http://github.com/myrridin/dalli-keys/'
  s.license     = 'MIT'

  s.add_runtime_dependency 'dalli', '2.7.2'
  s.add_development_dependency 'rspec', '3.3.0'
  s.add_development_dependency 'guard', '2.13.0'
  s.add_development_dependency 'guard-rspec', '4.6.4'
end