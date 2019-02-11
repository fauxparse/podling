require 'podling/engine'

module Podling
  mattr_accessor :episode_class

  def self.episode_class
    @@episode_class || Episode
  end
end
