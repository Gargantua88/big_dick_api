class AddHeadingIdToMaterials < ActiveRecord::Migration[5.2]
  def change
    add_reference :materials, :heading
  end
end
