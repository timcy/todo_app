class CreateDuties < ActiveRecord::Migration
  def change
    create_table :duties do |t|
      t.string   :name
      t.datetime :start_date    
      t.datetime :end_date
      t.string   :urgency
      t.string   :display_in
      t.boolean  :send_reminder
      t.integer  :created_by
      t.string   :repeat
      t.text     :notes
      t.timestamps
    end
  end
end
