require "tinyconfig/version"

class Tinyconfig < BasicObject
  class << self
    def option(option_name)
      option_name = option_name.to_sym
      define_method option_name do |*args|
        if args.length.zero?
          @_values[option_name]
        elsif args.length == 1
          @_values[option_name] = args.first
        else
          @_values[option_name] = args
        end
      end
    end
  end

  def initialize
    @_values = {}
  end

  def configure(&block)
    self.instance_eval(&block)
  end

  def load(path)
    full_path = ::File.join(::File.dirname(::Kernel.caller.first), path)
    self.instance_eval(::File.read(full_path), full_path, 0)
  end
end
