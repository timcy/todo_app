class CreateLists < ActiveRecord::Migration
  def change
    create_table :lists do |t|
      t.string  :heading
      t.timestamps
    end
  end
end
