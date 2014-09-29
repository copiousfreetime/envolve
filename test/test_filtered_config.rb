require 'test_helper'
require 'envolve/config'

class TestFilteredConfig < ::Minitest::Test
  def env
    { 'EV_X_TEST_1' => 'test-1',
      'EV_X_TEST_2' => 'test-2',
      'EV_TEST_3'   => 'test-3',
      'EV_TEST_4'   => 'test-4' }
  end

  def setup
    @config = Envolve::Config.new( env: env, prefix: 'ev_x' )
  end

  def test_access_key_as_method
    assert_equal( 'test-1', @config.test_1 )
  end

  def test_respond_to
    assert( @config.respond_to?( :test_2 ) )
  end

  def test_size
    assert( 2, @config.size )
  end

  def test_keys
    assert_equal( [ 'test_1', 'test_2'], @config.keys.sort )
  end


  def test_access
    assert_equal( 'test-2', @config['test_2'] )
  end

end
