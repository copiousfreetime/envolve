require 'test_helper'
require 'envolve/config'
require 'test_filtered_config'

class PrefixConfig < Envolve::Config
  def self.env
    { 'EV_X_TEST_1' => 'test-1',
      'EV_X_TEST_2' => 'test-2',
      'EV_TEST_3'   => 'test-3',
      'EV_TEST_4'   => 'test-4' }
  end

  environment_source( env )
  prefix 'ev_x'
end
class TestPrefixConfig < TestFilteredConfig
  def setup
    @config = PrefixConfig.new
  end
end
