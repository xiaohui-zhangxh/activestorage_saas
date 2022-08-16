require 'active_storage_saas/blob_model_mixin'
require 'active_storage_saas/direct_uploads_controller_mixin'
require 'active_storage_saas/storage_service_configuration_model_mixin'
module ActiveStorageSaas
  class Engine < Rails::Engine
    config.generators do |g|
      g.test_framework :rspec
    end
    config.active_storage_saas = ActiveSupport::OrderedOptions.new

    initializer "active_storage_saas.configs" do
      config.after_initialize do |app|
        default_service_resolver = ->(blob) { StorageServiceConfiguration.from_service_name(blob.service_name)&.to_service }
        default_service_name_converter = ->(controller) { StorageServiceConfiguration.first.to_service_name }
        default_service_name_validator = ->(service_name) { StorageServiceConfiguration.valid_service_name?(service_name) }
        default_direct_upload_extra_blob_args = ->(controller) { { } }
        ActiveStorageSaas.service_resolver              = app.config.active_storage_saas.service_resolver || default_service_resolver
        ActiveStorageSaas.service_name_converter        = app.config.active_storage_saas.service_name_converter || default_service_name_converter
        ActiveStorageSaas.service_name_validator        = app.config.active_storage_saas.service_name_validator || default_service_name_validator
        ActiveStorageSaas.direct_upload_extra_blob_args = app.config.active_storage_saas.direct_upload_extra_blob_args || default_direct_upload_extra_blob_args
        ActiveStorage::Blob # call this class to load mixin
      end

      config.to_prepare do
        ActiveStorage::DirectUploadsController.include ActiveStorageSaas::DirectUploadsControllerMixin
      end
    end

    config.to_prepare do
      ActionDispatch::Routing::Mapper.include Routes
    end

    initializer 'active_storage_saas.load_mixins' do
      ActiveSupport.on_load(:active_storage_blob) do
        include ActiveStorageSaas::BlobModelMixin
      end
    end
  end
end
