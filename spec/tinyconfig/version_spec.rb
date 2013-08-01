require 'spec_helper'

class TinyConfig
  describe VERSION do
    it 'is equal to itself' do
      expect { VERSION == ::TinyConfig::VERSION }
    end
  end
end
