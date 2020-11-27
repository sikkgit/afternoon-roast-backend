class StorySerializer < ActiveModel::Serializer
  attributes :id, :title, :html, :uuid, :tag

  belongs_to :tag
end