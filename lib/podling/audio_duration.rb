require 'taglib'

module Podling
  class AudioDuration
    include ActiveStorage::Downloading

    attr_reader :blob

    def initialize(blob)
      @blob = blob
    end

    def duration
      return @duration if @duration.present?

      download_blob_to_tempfile do |file|
        TagLib::FileRef.open(file.path) do |info|
          @duration = info.audio_properties&.length
        end
      end

      @duration
    end
  end
end
