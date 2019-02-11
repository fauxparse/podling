require_dependency 'podling/application_controller'

module Podling
  class EpisodesController < ApplicationController
    before_action :set_episode, only: %i[show edit update destroy]

    def index
      @episodes = Podling.episode_class.latest_first.all
    end

    def show; end

    def new
      @episode = Podling.episode_class.new
    end

    def edit; end

    def create
      @episode = Podling.episode_class.new(episode_params)

      if @episode.save
        redirect_to @episode, notice: 'Episode was successfully created.'
      else
        render :new
      end
    end

    def update
      if @episode.update(episode_params)
        redirect_to @episode, notice: 'Episode was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @episode.destroy
      redirect_to episodes_url, notice: 'Episode was successfully destroyed.'
    end

    private

    def set_episode
      @episode = Podling.episode_class.find(params[:id])
    end

    def episode_params
      params
        .require(:episode)
        .permit(:title, :description, :audio, :published_at, :deleted_at)
    end
  end
end
