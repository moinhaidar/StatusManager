class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :name
      t.string :description
      t.boolean :active, :default => true
      t.timestamps
    end
  end
end
