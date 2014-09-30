require 'test_helper'
require 'envolve/config'

class TestConfig < ::Minitest::Test
  def env
    { 'EV_TEST_1' => 'test-1',
      'EV_TEST_2' => 'test-2' }
  end

  def setup
    @config = Envolve::Config.new( env: env )
  end

  def test_access_key_as_method
    assert_equal( 'test-1', @config.ev_test_1 )
  end

  def test_respond_to
    assert( @config.respond_to?( :ev_test_2 ) )
  end

  def test_size
    assert( 2, @config.size )
  end

  def test_keys
    assert_equal( [ 'ev_test_1', 'ev_test_2'], @config.keys.sort )
  end


  def test_access
    assert_equal( 'test-2', @config['ev_test_2'] )
  end

  def test_config_with_prefix
    assert_equal( { 'test_1' => 'test-1', 'test_2' => 'test-2' }, @config.config_with_prefix( 'ev' ).to_h )
  end

end
