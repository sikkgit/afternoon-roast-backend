class StorySerializer < ActiveModel::Serializer
  attributes :id, :title, :html, :uuid, :tag, :formatted_date

  belongs_to :tag
end