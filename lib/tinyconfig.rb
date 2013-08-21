require "tinyconfig/version"

class TinyConfig < BasicObject
  class << self
    #
    # ### Define new option
    def option(option_name, default=nil, &block)
      option_name = option_name.to_sym
      getter_name = "__get__#{option_name}".to_sym
      validator = block_given? ? block : nil
      klass = self

      # Private getter method for the default
      # http://www.bofh.org.uk/2007/08/16/a-cunning-evil-trick-with-ruby
      meth = default.respond_to?(:call) ? default : ->{ default }
      define_method(getter_name, &meth)
      private(getter_name)

      define_method option_name do |*args|
        if args.length.zero?
          # No args -> get value
          self.__send__(getter_name)
        else
          # Args provided -> set value (i.e. define getter method on the singleton)
          if validator
            value = validator.call(*args)
          elsif args.length == 1
            value = args.first
          else
            value = args
          end
          meth = value.respond_to?(:call) ? value : ->{ value }
          (class << self ; self ; end).send(:define_method, getter_name, &meth)
        end
      end
    end
  end

  # make arrow lambdas work on Rubinius
  if ::RUBY_ENGINE == 'rbx'
    def lambda(*args, &block)
      ::Kernel.lambda(*args, &block)
    end
  end

  def initialize
    @_values = {}
  end

  def configure(&block)
    self.instance_eval(&block)
  end

  def load(glob)
    # If glob is relative, we want to interpret it relative to the
    # calling file (directory that contains the ruby source file that
    # has called the `TinyConfig#load` method) rather than whatever is
    # the process' `Dir.getwd`.

    glob = ::File.join(::File.dirname(::Kernel.caller.first), glob)

    load_helper(glob)
  end

  def load_in_bulk #Split to three lines for readability.
    directory_name = ::File.join(::File.dirname(::Kernel.caller.first), ::File.basename(::Kernel.caller.first, ".*"))
    
    bulk_file_source = ::File.join(directory_name, "*.rb")

    load_helper(bulk_file_source)
  end

  #
  # Compat methods
  # --------------

  def inspect
    _values = @_values.sort.map { |k,v| " #{k}=#{v.inspect}" }.join
    "#<#{__realclass__}#{_values}>"
  end

  alias_method :to_s, :inspect

  private

  def load_helper(source)
    ::Dir.glob(source).sort.each do |path|
    self.instance_eval(::File.read(path), path, 0)
    end
  end
  
  def __realclass__
    (class << self; self end).superclass
  end
end
