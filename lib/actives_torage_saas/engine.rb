module ActiveStorageSaas
  class Engine < Rails::Engine
    config.before_configuration do
      # disable active_storage routes
      ActiveStorage::Engine.config.paths['config/routes.rb'] = []
    end

    config.to_prepare do
      ActionDispatch::Routing::Mapper.include Routes
    end

    initializer 'patch' do
      ActiveSupport.on_load(:active_storage_blob) do
        include ActiveStorageSaas::BlobPatch
      end
    end
  end
end
