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

          sanitize_and_save_html(@newsletter, params[:html])

          @newsletter.add_stories(params[:stories])

          lyra_connection(item: @newsletter, type: 'newsletters', method: 'post')

          render json: @newsletter
        rescue => exception
          render json: {error: 'Error: Could not create newsletter'}
        end
      end

      def destroy
        begin
          @newsletter = Newsletter.find_by(id: params[:id])

          if @newsletter
            lyra_connection(item: @newsletter, type: 'newsletters', method: 'delete', uuid: @newsletter.uuid)

            @newsletter.destroy

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


