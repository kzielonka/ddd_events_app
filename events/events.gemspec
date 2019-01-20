# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = 'events'
  s.version     = '0.0.1'
  s.licenses    = []
  s.summary     = 'Events'
  s.authors     = ['Krzysztof Zielonka']
  s.files       = Dir.glob('lib/**/*')

  s.add_development_dependency 'rspec', '~> 3.8.0'

  s.add_runtime_dependency 'dry-struct', '~> 0.6.0'
  s.add_runtime_dependency 'dry-types', '~> 0.13'
  s.add_runtime_dependency 'rails_event_store', '~> 0.35.0'
end
