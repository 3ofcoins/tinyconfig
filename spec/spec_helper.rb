require 'rubygems'
require 'bundler/setup'

require 'minitest/autorun'
require 'minitest/spec'
require 'mocha/setup'
require 'wrong'

Wrong.config.alias_assert :expect, override: true

module TinyconfigSpec
  module WrongHelper
    include Wrong::Assert
    include Wrong::Helpers

    def increment_assertion_count
      self.assertions += 1
    end
  end
end

class MiniTest::Spec
  include TinyconfigSpec::WrongHelper
end

if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start
  SimpleCov.command_name 'rake spec'
end

require "tinyconfig"
