require 'spec_helper'

class BasicIdea < Tinyconfig
  option :opt
end

describe Tinyconfig do
  let(:cfg) { BasicIdea.new }

  it "defaults options' values to nil" do
    expect { cfg.opt.nil? }
  end

  it 'allows setting values in a block' do
    cfg.configure do
      opt 23
    end

    expect { cfg.opt == 23 }
  end

  it 'raises an exception when somebody tries to set undefined value' do
    expect { rescuing { cfg.configure { nopt -1 } }.is_a? NoMethodError }
  end

  it 'allows reading configuration from file' do
    cfg.read(fixture 'basic.rb')
    expect { cfg.opt == 23 }
  end
end
