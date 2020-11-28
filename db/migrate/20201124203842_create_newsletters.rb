class CreateNewsletters < ActiveRecord::Migration[6.0]
  def change
    create_table :newsletters do |t|
      t.string :title
      t.string :uuid
      t.text :description
      t.text :html

      t.timestamps
    end
  end
end
