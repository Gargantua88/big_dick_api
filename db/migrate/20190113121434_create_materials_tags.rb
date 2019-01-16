class CreateMaterialsTags < ActiveRecord::Migration[5.2]
  def change
    create_table :materials_tags do |t|
      t.references :material, foreign_key: true
      t.references :tag, foreign_key: true
    end
  end
end
