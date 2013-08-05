require 'tinyconfig'

class HelloConfig < TinyConfig
  option :recipient, 'World'

  option :repeat, 1 do |value|
    int_value = value.to_i
    if int_value < 1
      raise ::ArgumentError, "#{value.inspect} is not a number or is less than 1"
    end
    int_value
  end

  option :extra_greeting
end

cfg = HelloConfig.new
cfg.load ARGV.first if ARGV.first

cfg.repeat.times do
  puts "Hello, #{cfg.recipient}!"
end
puts cfg.extra_greeting if cfg.extra_greeting
