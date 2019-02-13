require 'podling/engine'
require 'podling/podcast'
require 'podling/audio_duration'

module Podling
  mattr_accessor :episode_class

  def self.episode_class
    @@episode_class || Episode
  end
end
