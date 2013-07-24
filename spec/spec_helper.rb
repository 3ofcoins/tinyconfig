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

  def fixture(filename)
    File.join(File.dirname(__FILE__), 'fixtures', filename)
  end
end

if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start
  SimpleCov.command_name 'rake spec'
end

# Make Tinyconfig pretty-printable.
require "tinyconfig"
class Tinyconfig
  begin
    old_verbose, $VERBOSE = $VERBOSE, nil
    def object_id ; __id__ ; end
  ensure
    $VERBOSE = old_verbose
  end

  def class
    __realclass__
  end

  def pretty_print(pp)
    pp.object_address_group(self) do
      pp.breakable
      pp.pp_hash(@_values)
    end
  end
end
