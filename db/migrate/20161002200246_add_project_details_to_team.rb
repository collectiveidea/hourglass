class AddProjectDetailsToTeam < ActiveRecord::Migration
  def change
    add_column :teams, :project_id, :integer
    add_column :teams, :project_name, :string
  end
end
