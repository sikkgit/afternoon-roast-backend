class NewsletterSerializer < ActiveModel::Serializer
  attributes :id, :title, :html, :uuid, :formatted_date, :stories, :description

  has_many :stories
end