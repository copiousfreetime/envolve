module Envolve
  # Public: A Configuration class to hold your application configuration
  #
  # Feed it ENV or some other Hash-like object and it will allow you to access
  # the elements in that hash via methods.
  #
  # You can also tell it to only pull those items from the initial has that have
  # a particular prefix, and that prefix will be stripped off of the elements
  # for access.
  class Config
    # Public: Return the default environment.
    #
    # Override this to return a different environment source
    def self.environment_source( *args, &block )
      if args.size > 0 then
        @_default_env = args.first
      elsif block_given? then
        @_default_env = block.call
      else
        @_default_env ||= ENV.to_hash
      end
    end

    # Public: Return the prefix to be used by the class
    #
    # Override this to return a different prefix, or meta program it in an
    # inherited class.
    def self.prefix( *args )
      if args.size > 0 then
        @_prefix = args.first
      else
        @_prefix = nil if !defined?( @_prefix )
      end
      @_prefix
    end

    # Public: Return the key_separator to be used by the class
    #
    # Override this to return a different key_separator, or meta program it in an
    # inherited class.
    def self.key_separator( *args, &block )
      if args.size > 0 then
        @_key_separator = args.first
      else
        @_key_separator = '_'.freeze if !defined?( @_key_separator )
      end
      @_key_separator
    end

    # Public: Set a transformation
    #
    # In the conversion of a the environment to the configuration properties
    # sometimes the keys and/or values need to be converted to a new name.
    #
    # All transformations take place AFTER the initial keys have been downcased
    # and prefix stripped.
    #
    # env_var - the environment varaible you want to perform transformations on.
    # key     - the new key for this environment variable
    # val     - the new value for this environment varaible.
    #
    # Both `key` and `value` can be direct string maps, or lambdas. If a lambda
    # is given then the original key or value (respectively) is passed into the
    # lambda.
    #
    def self.transform( env_var, key: nil, value: nil )
      transformations[env_var] = { :key => key, :value => value }
    end

    # Internal: Return the hash holding the transformations
    #
    # Returns Hash
    def self.transformations
      @_transformations ||= Hash.new
    end

    # Internal: The internal hash holding all the keys and values
    attr_reader :_env

    # Internal: The prefix to strip off all the keys
    attr_reader :_prefix

    # Internal: The character to use as the key separator
    attr_reader :_key_separator

    # Public: Create a new Config
    def initialize( env: self.class.environment_source, prefix: self.class.prefix,
                   key_separator: self.class.key_separator )
      @_key_separator = key_separator
      @_prefix        = prefix.nil? ? nil : prefix.to_s.downcase.strip
      @_env           = process_env( env )

    end


    # Internal: Process and Transform the keys and values from the environment
    # into the final hash
    #
    def process_env( env )
      env = downcase_keys( env )
      if _prefix then
        env = filter_by_prefix( env, _prefix )
      end
      env = apply_transformations( env, self.class.transformations )
    end

    # Internal: Apply the give transformations to the hash input
    #
    # Returns the transformed hash
    def apply_transformations( env, transformations )
      Hash.new.tap do |transformed|
        env.each do |key, value|
          if trans = transformations[key] then
            key   = apply_transformation(key, trans[:key]) if trans[:key]
            value = apply_transformation(value, trans[:value]) if trans[:value]
          end
          transformed[key] = value
        end
      end
    end

    # Internal: Apply the given transformation to the input.
    #
    # Returns the result of the transformation
    def apply_transformation( input, transformer )
      return input                     if transformer.nil?
      return transformer.call( input ) if transformer.respond_to?( :call )
      return transformer
    end

    # Public: The number of elements in the config
    #
    # Returns the number of elements
    def size
      _env.size
    end

    # Public: Just the keys, only the keys, as Strings
    #
    # Returns an Array of the keys as Strings
    def keys
      _env.keys
    end

    # Public: return the value for the give key
    #
    # key - the String key to use for fetching
    #
    # Returns value or nil if no value is found
    def []( key )
      _env[key]
    end

    # Public: Return a subset of the config with just those items that have a
    # prefix on them
    #
    # The resulting Config only has those keys, and all with the prefixes
    # stripped
    def config_with_prefix( prefix )
      self.class.new( env: _env, prefix: prefix )
    end

    # Public: Return as hash of the keys and values
    #
    # Returns a Hash
    def to_h
      _env.to_h.dup
    end
    alias to_hash to_h

    # Public: Return a hash of the keys and values with the keys as symbols.
    #
    # Returns a Hash
    def to_symbolized_h
      h = {}
      _env.each do |key, value|
        h[key.to_sym] = value
      end
      return h
    end
    alias to_symbolized_hash to_symbolized_h

    # Internal: This is how we convert method calls into key lookups in the
    # internal hash.
    def method_missing( method, *args, &block )
      s_method = method.to_s
      if _env.has_key?( s_method ) then
        _env[ s_method ]
      else
        super
      end
    end

    # Internal: Respond to missing should always be implemented if you implement
    # method_missing
    def respond_to_missing?( symbol, include_all = false )
      _env.has_key?( symbol.to_s ) || super
    end

    # Internal: The prefix regular expression used for stripping leading prefix
    #
    # This matches Beginning of String followed by the prefix followed by 0 or
    # more key_separator characters.
    #
    # This will use named captures. The prefix will be under key 'prefix' and
    # the following will be under 'rest'
    #
    # Returns the regex
    def prefix_regex( prefix, key_separator  )
      /\A(?<prefix>#{prefix}[#{key_separator}]*)(?<rest>.*)\Z/i
    end


    private

    # Return a copy of the hash filtered by the prefix.
    #
    # All the keys that match the prefix will have hte prefix stripped off. All
    # others will be ignored
    def filter_by_prefix( in_hash, pre = _prefix, ks = _key_separator )
      out_hash = {}
      matcher  = prefix_regex( pre, ks )
      in_hash.each do |key, value|
        if md = matcher.match( key ) then
          out_hash[ md[:rest] ] = value
        end
      end
      return out_hash
    end

    # Return a copy of the hash with all the keys downcased
    def downcase_keys( in_hash )
      out_hash = {}
      in_hash.each do |key, value|
        out_hash[key.downcase] = value
      end
      return out_hash
    end
  end
end
