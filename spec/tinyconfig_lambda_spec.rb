require 'spec_helper'

class LambdaExample < TinyConfig
  option :foo
  option :bar, ->{ "Bar for foo=#{foo.inspect}" }
  option :baz
end

describe TinyConfig do
  let(:cfg) { LambdaExample.new }

  it "evaluates lambda default in runtime" do
    expect { cfg.bar == "Bar for foo=nil" }
    cfg.configure do
      foo 23
    end
    expect { cfg.bar == "Bar for foo=23" }
  end

  it "evaluates lambda value in runtime" do
    cfg.configure do
      baz ->{ bar.reverse }
    end

    expect { cfg.baz == "lin=oof rof raB" }

    cfg.configure do
      foo 23
    end
    expect { cfg.baz == "32=oof rof raB" }
  end

  it "sets instance methods rather than class methods" do
    cfg2 = LambdaExample.new
    cfg.configure do
      foo 23
    end
    expect { cfg.foo == 23 }
    expect { cfg.bar == "Bar for foo=23" }
    expect { cfg2.foo.nil? }
    expect { cfg2.bar == "Bar for foo=nil" }
  end
end
