class ActivestorageSaasTables < ActiveRecord::Migration[5.2]
  def change
    tenant_class = ActiveStorageSaas.tenant_class_name.constantize
    tenant_primary_key = tenant_class.columns.find{|col| col.name == tenant_class.primary_key }
    create_table :tenant_storage_services do |t|
      t.references :tenant, type: tenant_primary_key.type, foreign_key: { to_table: tenant_class.table_name }
      t.string :service_name
      t.json :service_options

      t.timestamps
    end

    add_reference tenant_class.table_name.to_sym, :tenant_storage_service, foreign_key: true
    add_reference :active_storage_blobs, :tenant, type: tenant_primary_key.type, foreign_key: true
    add_reference :active_storage_blobs, :tenant_storage_service, foreign_key: true
  end
end
