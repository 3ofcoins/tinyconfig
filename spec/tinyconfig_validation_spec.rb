require 'spec_helper'

class ValidatingConfig < Tinyconfig
  option :integer do |value|
    if value.strip !~ /^[-\d]/
      raise ::ArgumentError, "Not an integer: #{value.inspect}"
    else
      value.to_i
    end
  end
end

describe Tinyconfig do
  let(:cfg) { ValidatingConfig.new }

  it 'calls provided block to transform and/or validate value' do
    cfg.configure do
      integer '23'
    end
    expect { cfg.integer == 23 }
  end

  it 'can raise exception from the validation block' do
    expect do
      rescuing do
        cfg.configure do
          integer 'dupa'
        end
      end.is_a?(ArgumentError)
    end
  end
end
