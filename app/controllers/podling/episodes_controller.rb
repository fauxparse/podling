require_dependency 'podling/application_controller'

module Podling
  class EpisodesController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :render_404

    layout '/application'

    def index; end

    def show; end

    private

    def episodes
      @episodes ||= scope.all
    end

    helper_method :episodes

    def episode
      @episode ||= scope.find(params[:id])
    end

    helper_method :episode

    def scope
      Podling.episode_class.published.latest_first
    end

    def render_404
      head :not_found
    end
  end
end
