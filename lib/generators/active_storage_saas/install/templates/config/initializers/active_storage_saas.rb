Rails.application.configure do
  # config.active_storage_saas.service_resolver = ->(blob) { StorageServiceConfiguration.from_service_name(blob.service_name)&.to_service }
  # config.active_storage_saas.service_name_converter = ->(controller) { controller.send(:current_tenant).storage_service&.to_service_name }
  # config.active_storage_saas.service_name_validator = ->(service_name) { StorageServiceConfiguration.valid_service_name?(service_name) }
  # config.active_storage_saas.direct_upload_extra_blob_args = ->(controller) { { tenant: controller.send(:current_tenant) } }
end
