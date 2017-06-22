class CreateResponsibilities < ActiveRecord::Migration
  class Responsibility < ActiveRecord::Base
  end

  def up
    if ENV["HARVEST_INTERNAL_CLIENT_ID"].blank?
      raise "HARVEST_INTERNAL_CLIENT_ID must be set."
    end

    create_table :responsibilities, id: :uuid do |t|
      t.string :title
      t.string :adjective
      t.text :harvest_client_ids, array: true, default: [], null: false
      t.boolean :default, null: false, default: false
      t.integer :position
      t.timestamps null: false
    end

    Responsibility.create!([
      {
        title: "Client",
        adjective: "client",
        default: true,
        position: 1
      },
      {
        title: "Internal",
        adjective: "internal",
        harvest_client_ids: [ENV["HARVEST_INTERNAL_CLIENT_ID"]],
        position: 2
      }
    ])

    add_index :responsibilities, :harvest_client_ids, using: :gin
    add_index :responsibilities, :position
  end

  def down
    drop_table :responsibilities
  end
end
