module ActiveStorageSaas
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path("templates", __dir__)
    class_option :configuration_model, type: :string, default: 'StorageServiceConfiguration'

    def generate_model
      generate "model", "#{options['configuration_model']} service_name service_options:json"
      inject_into_file "app/models/#{options['configuration_model'].underscore}.rb", after: /^class .+\n/ do <<-'RUBY'
  include ActiveStorageSaas::StorageServiceConfigurationMixin

RUBY
      end
    end

    def copy_files
      template 'config/initializers/active_storage_saas.rb'
    end
  end
end
