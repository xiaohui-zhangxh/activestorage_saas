class CreateStorageServiceConfigurations < ActiveRecord::Migration[7.0]
  def change
    create_table :storage_service_configurations do |t|
      t.string :service_name
      t.json :service_options

      t.timestamps
    end
  end
end
