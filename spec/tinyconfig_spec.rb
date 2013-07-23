require 'spec_helper'

class BasicIdea < Tinyconfig
  option :opt
end

describe Tinyconfig do
  let(:cfg) { BasicIdea.new }

  it "defaults options' values to nil" do
    expect { cfg.opt.nil? }
  end

  describe '#configure' do
    it 'configures in a block' do
      cfg.configure do
        opt 23
      end

      expect { cfg.opt == 23 }
    end
  end

  it 'raises an exception when somebody tries to set undefined value' do
    expect { rescuing { cfg.configure { nopt -1 } }.is_a? NoMethodError }
  end

  describe '#load' do
    it 'loads configuration from file relative to the caller' do
      cfg.load('fixtures/basic.rb')
      expect { cfg.opt == 23 }
    end

    it "can be nested" do
      cfg.load('fixtures/basic_nested.rb')
      expect { cfg.opt == 23 }
    end
  end
end
