# frozen_string_literal: true

require_relative 'lib/legion/extensions/cognitive_echo_chamber/version'

Gem::Specification.new do |spec|
  spec.name          = 'lex-cognitive-echo-chamber'
  spec.version       = Legion::Extensions::CognitiveEchoChamber::VERSION
  spec.authors       = ['Esity']
  spec.email         = ['matthewdiverson@gmail.com']

  spec.summary       = 'Cognitive echo chamber dynamics for LegionIO agentic architecture'
  spec.description   = 'Models cognitive echo chambers — when thoughts reinforce themselves without ' \
                       'external challenge, creating self-reinforcing belief loops. Tracks amplification, ' \
                       'resonance, and breakthrough events when external input disrupts the echo.'
  spec.homepage      = 'https://github.com/LegionIO/lex-cognitive-echo-chamber'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 3.4'

  spec.metadata['homepage_uri']          = spec.homepage
  spec.metadata['source_code_uri']       = 'https://github.com/LegionIO/lex-cognitive-echo-chamber'
  spec.metadata['documentation_uri']     = 'https://github.com/LegionIO/lex-cognitive-echo-chamber/blob/master/README.md'
  spec.metadata['changelog_uri']         = 'https://github.com/LegionIO/lex-cognitive-echo-chamber/blob/master/CHANGELOG.md'
  spec.metadata['bug_tracker_uri']       = 'https://github.com/LegionIO/lex-cognitive-echo-chamber/issues'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.require_paths = ['lib']
  spec.add_development_dependency 'legion-gaia'
end
