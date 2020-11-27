class CreateStories < ActiveRecord::Migration[6.0]
  def change
    create_table :stories do |t|
      t.string :title
      t.text :html
      t.string :uuid
      t.integer :tag_id
      t.integer :newsletter_id

      t.timestamps
    end
  end
end
