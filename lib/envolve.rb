module Envolve
  # Public: load the environment into a Config and return it.
  #
  def self.load( env = ENV )
    Envolve::Config.new( env )
  end
end
require 'envolve/version'
require 'envolve/config'
