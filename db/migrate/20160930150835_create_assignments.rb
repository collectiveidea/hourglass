class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.integer :team_id
      t.uuid :user_id
      t.integer :hours

      t.timestamps null: false
    end
  end
end
