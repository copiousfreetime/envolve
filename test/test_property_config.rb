require 'test_helper'
require 'envolve/config'

class TestPropertyConfig < ::Minitest::Test
  class PropertyConfig < ::Envolve::Config
    environment_source {
      {
        'EV_TEST_1' => 'test-1',
        'EV_TEST_2' => 'test-2',
        'EV_FOO'    => 'test-bar',
        'EV_WIBBLE' => 'wobble',
      }
    }

    prefix 'ev'

    property 'bar',    :key => 'foo'
    property 'wibble', :value => lambda { |val| val.gsub('o', 'ee') }
    property 'ara',    :default => 42, :value => lambda { |val| Integer(val) }

  end

  class PropertyMustConfig < ::Envolve::Config
    property 'envolve_test_must',   :required => true
  end

  class PrefixPropertyMustConfig < ::Envolve::Config
    prefix 'envolve_test'
    property 'required_property',   :required => true
  end

  def setup
    @config = PropertyConfig.new
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

  def test_required_property
    env = ENV.to_hash.dup.merge( 'ENVOLVE_TEST_MUST' => "here" )
    c = PropertyMustConfig.new( env: env )
    assert_equal( "here", c.envolve_test_must )
  end


  def test_required_property_raises_missing
    assert_raises(::Envolve::MissingPropertyError) {
      PropertyMustConfig.new
    }
  end

  def test_required_property_error_message
    begin
      PropertyMustConfig.new
    rescue ::Envolve::MissingPropertyError => e
      assert_match( /\s+ENVOLVE_TEST_MUST\Z/, e.message )
    end
  end

  def test_required_property_error_message_includes_prefix
    begin
      PrefixPropertyMustConfig.new
    rescue ::Envolve::MissingPropertyError => e
      assert_match( /\s+ENVOLVE_TEST_REQUIRED_PROPERTY\Z/, e.message )
    end
  end

end
