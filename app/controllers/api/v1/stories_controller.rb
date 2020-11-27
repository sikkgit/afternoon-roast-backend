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
            @story.sanitize_and_update_html(params[:html])

            tag = Tag.find_or_create_by(name: params[:tag])
            @story.update(tag: tag)
            @story.save

            @story.lyra_connection('patch', @story.uuid)

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
          tag = Tag.find_or_create_by(name: params[:tag])        
          @story = Story.create(title: params[:title], tag: tag)

          @story.add_sanitized_html(params[:html])
          @story.lyra_connection('post')

          render json: @story

        rescue => exception
          render json: {error: 'Error: Could not create story'}
        end
      end
    end
  end
end
