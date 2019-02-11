module Podling
  class Episode < ApplicationRecord
    has_one_attached :audio

    validates :title, presence: true

    def self.latest_first
      order(published_at: :desc)
    end

    def self.published
      where('published_at IS NOT NULL AND published_at < :now ' \
            'AND (deleted_at IS NULL OR deleted_at > :now)', now: Time.now)
    end

    def self.deleted
      where('deleted_at IS NOT NULL AND deleted_at < ?', Time.now)
    end

    def published?
      published_at&.past? && !deleted?
    end

    def publish!
      update!(published_at: Time.now)
      self
    end

    def deleted?
      deleted_at&.past?
    end

    def delete!
      update!(deleted_at: Time.now)
      self
    end
  end
end
