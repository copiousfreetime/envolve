require 'test_helper'
require 'envolve/config'
require 'test_config'

class LambdaConfig < Envolve::Config
  environment_source {
    { 'EV_TEST_1' => 'test-1', 'EV_TEST_2' => 'test-2' } 
  }
end

class TestMetaConfig < ::TestConfig
  def setup
    @config = LambdaConfig.new
  end
end

