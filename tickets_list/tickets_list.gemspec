Gem::Specification.new do |s|
  s.name        = 'tickets_list'
  s.version     = '0.0.1'
  s.licenses    = []
  s.summary     = 'Tickets list'
  s.authors     = ['Krzysztof Zielonka']
  s.files       = Dir.glob('lib/**/*')

  s.add_development_dependency 'rspec', '~> 3.8.0'
  s.add_development_dependency 'database_cleaner', '~> 1.7.0'

  s.add_runtime_dependency 'events'
end
