# Tinyconfig

TinyConfig provides a base class to create a Ruby configuration file
loader.

The resulting configuration file is usable for people not familiar
with Ruby, but it is possible for a power user to use full power of
Ruby to script the configuration

## Installation

Add this line to your application's Gemfile:

    gem 'tinyconfig'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tinyconfig

## Usage

First, define your configuration class by creating a subclass of
`TinyConfig`. Use `option` method to define known options. You may
provide a default value as a second argument, and a
validator/postprocessing as a block.

The block receives one argument: value as provided by user. It should
raise `::ArgumentError` if the provided value is invalid, and return
the desired value otherwise. See the `example/hello.rb` file for a
sample usage:

```ruby
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
```

```
$ ruby hello.rb
Hello, World!
$ cat config1.rb
recipient 'You'
$ ruby hello.rb config1.rb
Hello, You!
$ cat config2.rb
repeat 3
$ ruby hello.rb config2.rb
Hello, World!
Hello, World!
Hello, World!
$ bundle outdated
$ cat config3.rb
repeat '2'
extra_greeting 'Really, hello!'
$ ruby hello.rb config3.rb
Hello, World!
Hello, World!
Really, hello!
$ cat config-invalid.rb
repeat 'whatever'
$ ruby hello.rb config-invalid.rb
hello.rb:9:in `block in <class:HelloConfig>': "whatever" is not a number or is less than 1 (ArgumentError)
	from /Users/japhy/Projekty/tinyconfig/lib/tinyconfig.rb:16:in `call'
	from /Users/japhy/Projekty/tinyconfig/lib/tinyconfig.rb:16:in `block in option'
	from ./config-invalid.rb:in `load'
	from /Users/japhy/Projekty/tinyconfig/lib/tinyconfig.rb:36:in `instance_eval'
	from /Users/japhy/Projekty/tinyconfig/lib/tinyconfig.rb:36:in `load'
	from hello.rb:18:in `<main>'
```

You can use the `load` method multiple times from your code, or you
can `load` other files from your config files. The method also accepts
glob expressions (e.g. `load 'config_*.rb'`).

You can also use `cfg.configure` method to update the configuration
inline in a block.

When you provide a lambda as a default or provided value, it will be
called at runtime to determine the value. This way you can use
settings that are not yet specified when the config file is being
read:

```ruby
class LambdaExample < TinyConfig
  option :foo
  option :bar, ->{ "Bar for foo=#{foo.inspect}" }
  option :baz
end

cfg = LambdaExample.new
cfg.bar # => "Bar for foo=nil"

cfg.configure do
  foo 23
end
cfg.bar # => "Bar for foo=23"

cfg.configure do
  baz ->{ bar.reverse }
end
cfg.baz # => "32=oof rof raB"
```

For details and corner cases, look into `spec/` for the test cases.

## Acknowledements

TinyConfig has been heavily inspired by Opscode's
[Mixlib::Config](https://github.com/opscode/mixlib-config). We chose
to implement our own tool, because `Mixlib::Config` configuration is
global, which makes it very hard to provide isolation between test
cases in the unit tests. TinyConfig is instance-based, which is easier
to manage locally.

## Contributing

See the [CONTRIBUTING.md](CONTRIBUTING.md) file
