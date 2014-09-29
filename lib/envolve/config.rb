module Envolve
  class Config
    attr_reader :env

    extend Forwardable
    def_delegators :@env, :size, :keys, :[], :values, :each, :each_key, :each_value

    def initialize( env = ENV )
      @env = downcase_keys( env )
    end


    def respond_to_missing?( symbol, include_all = false )
      env.has_key?( symbol.to_s ) || super
    end

    def method_missing( method, *args, &block )
      s_method = method.to_s
      if env.has_key?( s_method ) then
        env[ s_method ]
      else
        super
      end
    end

    private

    def downcase_keys( hash )
      new_hash = {}
      hash.each do |key, value|
        new_hash[key.downcase] = value
      end
      return new_hash
    end
  end
end
