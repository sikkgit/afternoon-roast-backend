module Api
  module V1
    class StoriesController < ApplicationController

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
