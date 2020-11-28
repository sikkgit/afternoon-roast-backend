module Api
  module V1
    class NewslettersController < ApplicationController
      def index
        newsletters = Newsletter.all
        render json: newsletters
      end

      def show
        @newsletter = Newsletter.find_by(id: params[:id])

        if !@newsletter
          render json: {error: 'Error: Newsletter not found'}
        else
          render json: @newsletter
        end
      end

      def create
        begin
          @newsletter = Newsletter.create(title: params[:title], description: params[:description])

          @newsletter.add_sanitized_html(params[:html])

          @newsletter.add_stories(params[:stories])

          @newsletter.lyra_connection('post')

          render json: @newsletter

        rescue => exception
          render json: {error: 'Error: Could not create newsletter'}
        end
      end

      def destroy
        begin
          @newsletter = Newsletter.find_by(id: params[:id])

          if @newsletter
            @newsletter.destroy
            @newsletter.lyra_connection('delete', @newsletter.uuid)
            render json: @newsletter
          else
            render json: {error: 'Error: Delete unsuccessful'}
          end
        rescue => exception
          render json: {error: 'Error: Delete unsuccessful'}
        end
      end
    end
  end
end


