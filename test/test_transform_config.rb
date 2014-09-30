require 'test_helper'
require 'envolve/config'

class TransformedConfig < ::Envolve::Config
  environment_source {
    {
      'EV_TEST_1' => 'test-1',
      'EV_TEST_2' => 'test-2',
      'EV_FOO'    => 'test-bar',
      'EV_WIBBLE' => 'wobble',
    }
  }

  prefix 'ev'

  transform 'foo', :key => 'bar'
  transform 'wibble', :value => lambda { |val| val.gsub('o', 'ee') }
  transform 'ara', :default => 42, :value => lambda { |val| Integer(val) }

end

class TestTransformedConfig < ::Minitest::Test
  def setup
    @config = TransformedConfig.new
  end


  def test_access_key_as_method
    assert_equal( 'test-1', @config.test_1 )
  end

  def test_respond_to
    assert( @config.respond_to?( :test_2 ) )
  end

  def test_size
    assert( 4, @config.size )
  end

  def test_keys
    keys = %w[ test_1 test_2 bar wibble ara].sort
    assert_equal( keys, @config.keys.sort )
  end

  def test_access
    assert_equal( 'weebble', @config['wibble'] )
  end

  def test_defaults
    assert_equal( 42, @config['ara'] )
  end

end
