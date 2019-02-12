require_dependency 'podling/application_controller'

module Podling
  module Admin
    class EpisodesController < Podling::ApplicationController
      layout '/application'

      def index; end

      def show; end

      def new
        @episode = scope.new
      end

      def edit; end

      def create
        @episode = scope.new(episode_params)

        if episode.save
          redirect_to admin_episode_path(episode),
                      notice: 'Episode was successfully created.'
        else
          render :new
        end
      end

      def update
        if episode.update(episode_params)
          redirect_to admin_episode_path(episode),
                      notice: 'Episode was successfully updated.'
        else
          render :edit
        end
      end

      def destroy
        episode.delete!
        redirect_to admin_episodes_path,
                    notice: 'Episode was successfully destroyed.'
      end

      private

      def episodes
        @episodes ||= scope.latest_first.all
      end

      helper_method :episodes

      def episode
        @episode ||= scope.find(params[:id])
      end

      helper_method :episode

      def scope
        Podling.episode_class.latest_first
      end

      def episode_params
        return {} if params[:episode].blank?

        params
          .require(:episode)
          .permit(:title, :description, :audio, :publish)
      end
    end
  end
end
