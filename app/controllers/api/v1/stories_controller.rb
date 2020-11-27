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

      def create
        begin
          tag = Tag.find_or_create_by(name: params[:tag])        
          @story = Story.create(title: params[:title], tag: tag)

          @story.add_sanitized_html(params[:html])
          @story.post_to_lyra()

          render json: @story

        rescue => exception
          render json: {error: 'Error: Could not create story'}
        end
      end
    end
  end
end
