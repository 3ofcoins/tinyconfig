require 'spec_helper'

class BasicIdea < TinyConfig
  option :opt
  option :defopt, 23
end

describe TinyConfig do
  let(:cfg) { BasicIdea.new }

  describe ".option" do
    it "defaults options' values to nil" do
      expect { cfg.opt.nil? }
    end

    it "sets default to a provided value" do
      expect { cfg.defopt == 23 }
    end
  end

  describe "#configure" do
    it "configures in a block" do
      cfg.configure do
        opt 23
      end

      expect { cfg.opt == 23 }
    end

    it "also accepts a string" do
      cfg.configure "opt 23"
      expect { cfg.opt == 23 }
    end
  end

  describe "#load" do
    it "loads configuration from file relative to the caller" do
      cfg.load("fixtures/basic.rb")
      expect { cfg.opt == 23 }
    end

    it "can be nested" do
      cfg.load("fixtures/basic_nested.rb")
      expect { cfg.opt == 23 }
    end

    it "can load files by a glob expression" do
      cfg.load("fixtures/glob*.rb")
      expect { cfg.opt == 17 }
    end

    it 'will handle absolute paths/globs correctly' do
      cfg.load(File.join(File.dirname(__FILE__), 'fixtures/basic.rb'))
      expect { cfg.opt == 23 }

      cfg.load(File.join(File.dirname(__FILE__), 'fixtures/basic_nested.rb'))
      expect { cfg.opt == 23 }

      cfg.load(File.join(File.dirname(__FILE__), 'fixtures/glob*.rb'))
      expect { cfg.opt == 17 }
    end
  end

  describe "#bulk_load" do
    it "loads all files in the directory next to current config file, of the same name as current config" do
      cfg.load("fixtures/directory.rb")
      expect { cfg.opt == 17 }
    end
  end

  describe "(configuration block)" do
    it "raises an exception when somebody tries to set undefined value" do
      expect { rescuing { cfg.configure { nopt -1 } }.is_a? NoMethodError }
    end

    it "overrides default values" do
      cfg.configure { defopt 17 }
      expect { cfg.defopt == 17 }
    end
  end
end
