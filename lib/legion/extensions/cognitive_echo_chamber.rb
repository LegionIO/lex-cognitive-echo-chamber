# frozen_string_literal: true

require 'securerandom'
require_relative 'cognitive_echo_chamber/version'
require_relative 'cognitive_echo_chamber/helpers/constants'
require_relative 'cognitive_echo_chamber/helpers/echo'
require_relative 'cognitive_echo_chamber/helpers/chamber'
require_relative 'cognitive_echo_chamber/helpers/chamber_engine'
require_relative 'cognitive_echo_chamber/runners/cognitive_echo_chamber'
require_relative 'cognitive_echo_chamber/client'

module Legion
  module Extensions
    module CognitiveEchoChamber
      extend Legion::Extensions::Core if Legion::Extensions.const_defined? :Core
    end
  end
end
