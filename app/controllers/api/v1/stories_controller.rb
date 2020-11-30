module Api
  module V1
    class StoriesController < ApplicationController
      def index
        stories = Story.all
        render json: stories
      end

      def show
        @story = Story.find_by(id: params[:id])

        if !@story
          render json: {error: 'Error: Story not found'}
        else
          render json: @story
        end
      end

      def update
        begin
          @story = Story.find_by(id: params[:id])

          if @story
            @story.update(title: params[:title])

            sanitize_and_save_html(@story, params[:html])

            find_and_save_tag(@story, params[:tag])

            lyra_connection(item: @story, type: 'stories', method: 'patch', uuid: @story.uuid)

            render json: @story
          else
            render json: {error: 'Error: Story update unsuccessful'}
          end
          
        rescue => exception
          render json: {error: 'Error: Story update unsuccessful'}
        end
      end

      def create
        begin
          @story = Story.create(title: params[:title])

          find_and_save_tag(@story, params[:tag])

          sanitize_and_save_html(@story, params[:html])

          lyra_connection(item: @story, type: 'stories', method: 'post')

          render json: @story
        rescue => exception
          render json: {error: 'Error: Could not create story'}
        end
      end

      def destroy
        begin
          @story = Story.find_by(id: params[:id])

          if @story
            @story.destroy

            lyra_connection(item: @story, type: 'stories', method: 'delete', uuid: @story.uuid)

            render json: @story
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
