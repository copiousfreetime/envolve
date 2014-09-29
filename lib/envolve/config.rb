module Envolve
  # Public: A Configuration class to hold your application configuration
  #
  # Feed it ENV or some other Hash-like object and it will allow you to access
  # the elements in that hash via methods.
  #
  # You can also tell it to only pull those items from the initial has that have
  # a particular prefix
  class Config
    DEFAULT_KEY_SEPARATOR = '_'.freeze

    # Internal: The internal hash holding all the keys and values
    attr_reader :env

    # Public: Create a new Config
    def initialize( env: ENV, prefix: nil, key_separator: DEFAULT_KEY_SEPARATOR )
      @key_separator = key_separator
      @env = downcase_keys( env )
    end

    # Public: The number of elements in the config
    #
    # Returns the number of elements
    def size
      env.size
    end

    # Public: Just the keys, only the keys, as Strings
    #
    # Returns an Array of the keys as Strings
    def keys
      env.keys
    end

    # Public: return the value for the give key
    #
    # key - the String key to use for fetching
    #
    # Returns value or nil if no value is found
    def []( key )
      env[key]
    end

    # Internal: This is how we convert method calls into key lookups in the
    # internal hash.
    def method_missing( method, *args, &block )
      s_method = method.to_s
      if env.has_key?( s_method ) then
        env[ s_method ]
      else
        super
      end
    end

    # Internal: Respond to missing should always be implemented if you implement
    # method_missing
    def respond_to_missing?( symbol, include_all = false )
      env.has_key?( symbol.to_s ) || super
    end


    private

    def downcase_keys( in_hash )
      out_hash = {}
      in_hash.each do |key, value|
        out_hash[key.downcase] = value
      end
      return out_hash
    end

    def symbolize_keys( in_hash )
      out_hash = {}
      in_hash.each do |key, value|
        out_hash[key.to_sym] = value
      end
      return out_hash
    end
  end
end
