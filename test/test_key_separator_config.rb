require 'test_helper'
require 'envolve/config'
require 'test_config'

class KeySeparatorConfig < Envolve::Config
  environment_source {
    { 'EV-TEST-1' => 'test-1', 'EV-TEST-2' => 'test-2' } 
  }
  key_separator '-' 
end

class TestKeySeparatorConfig < ::TestConfig
  def setup
    @config = LambdaConfig.new
  end
end

