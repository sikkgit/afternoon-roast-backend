class Story < ApplicationRecord
  belongs_to :tag, optional: true
  belongs_to :newsletter, optional: true

  def formatted_date
    self.created_at.in_time_zone('Eastern Time (US & Canada)').strftime("%Y-%m-%d")
  end
end



