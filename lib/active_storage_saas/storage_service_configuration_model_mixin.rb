module ActiveStorageSaas
  module StorageServiceConfigurationMixin
    extend ActiveSupport::Concern

    included do
      prepend InstanceMethods
    end

    prepended do
      prepend InstanceMethods
    end

    module InstanceMethods
      extend ActiveSupport::Concern

      class_methods do
        def service_name_pattern
          /^#{name}:(\d+)$/
        end

        def from_service_name(service_name)
          find_by(id: Regexp.last_match(1)) if service_name =~ service_name_pattern
        end

        def valid_service_name?(service_name)
          service_name_pattern.match?(service_name)
        end
      end

      def to_service
        defined_service = ActiveStorage::Blob.services.fetch(service_name)
        klass = defined_service.class
        options = ActiveStorage::Blob.services.send(:configurations).fetch(service_name.to_sym)
        options.deep_merge! service_options.deep_symbolize_keys
        klass.new(**options).tap do |instance|
          instance.instance_eval <<~RUBY
            define_singleton_method(:name) { "#{to_service_name}" }
          RUBY
        end
      end

      def to_service_name
        "#{self.class.name}:#{id}"
      end
    end
  end
end
