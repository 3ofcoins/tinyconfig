require 'spec_helper'

class Tinyconfig
  describe VERSION do
    it 'is equal to itself' do
      expect { VERSION == Tinyconfig::VERSION }
    end
  end
end
