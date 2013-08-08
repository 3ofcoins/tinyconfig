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
