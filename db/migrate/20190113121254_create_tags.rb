class CreateTags < ActiveRecord::Migration[5.2]
  def change
    create_table :tags do |t|
      t.string :slug, index: true
      t.string :title, index: true

      t.timestamps
    end
  end
end
