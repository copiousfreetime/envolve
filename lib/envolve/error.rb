module Envolve
  class Error < ::StandardError; end
  class MissingPropertyError < Error
    def self.raise(_prefix, env_var)
      Kernel.raise(self, "Missing environment variable #{[ _prefix, env_var].compact.join('_').upcase}")
    end
  end
end
