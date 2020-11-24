class Story < ApplicationRecord
  belongs_to :tag
  belongs_to :newsletter
end
