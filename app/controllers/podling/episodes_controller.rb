require_dependency 'podling/application_controller'

module Podling
  class EpisodesController < ApplicationController
    before_action :set_episode, only: %i[edit update destroy]

    rescue_from ActiveRecord::RecordNotFound, with: :render_404

    def index; end

    def show; end

    def new
      @episode = Podling.episode_class.new
    end

    def edit; end

    def create
      @episode = Podling.episode_class.new(episode_params)

      if episode.save
        redirect_to episodes_path, notice: 'Episode was successfully created.'
      else
        render :new
      end
    end

    def update
      if episode.update(episode_params)
        redirect_to episodes_path, notice: 'Episode was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      episode.delete!
      redirect_to episodes_path, notice: 'Episode was successfully deleted.'
    end

    private

    def episodes
      @episodes ||= scope.all
    end

    helper_method :episodes

    def episode
      @episode ||= scope.find(params[:id])
    end

    helper_method :episode

    def set_episode
      @episode = Podling.episode_class.find(params[:id])
    end

    def episode_params
      return {} if params[:episode].blank?

      params
        .require(:episode)
        .permit(:title, :description, :audio, :publish)
    end

    def scope
      Podling.episode_class.published.latest_first
    end

    def render_404
      head :not_found
    end
  end
end
