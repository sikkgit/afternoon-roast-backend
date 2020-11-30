class Newsletter < ApplicationRecord
  has_many :stories

  def formatted_date
    self.created_at.in_time_zone('Eastern Time (US & Canada)').strftime("%Y-%m-%d")
  end

  def add_stories(stories)
    stories.each do |s|
      found_story = Story.find_by(id: s["id"])

      if found_story
        found_story.newsletter = self
        found_story.save
      end
    end

    return true
  end
end
