class CreateUsers < ActiveRecord::Migration
  def change
    enable_extension "uuid-ossp"

    create_table :users, id: :uuid do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :harvest_id, null: false
      t.string :zenefits_name, null: false
      t.string :time_zone, null: false
      t.timestamps null: false
    end
  end
end
