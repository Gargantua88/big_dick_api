class CreateMaterials < ActiveRecord::Migration[5.2]
  def change
    create_table :materials do |t|
      t.string :title
      t.text :announcement
      t.string :cover_url
      t.text :body
      t.string :link, index: true
      t.timestamp :published_date, index: true

      t.timestamps
    end
  end
end
