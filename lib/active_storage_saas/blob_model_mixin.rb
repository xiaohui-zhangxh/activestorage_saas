require 'active_storage/service/saas_service'

module ActiveStorageSaas
  module BlobModelMixin
    extend ActiveSupport::Concern

    included do
      prepend InstanceMethods
    end

    prepended do
      prepend InstanceMethods
    end

    module InstanceMethods
      extend ActiveSupport::Concern

      prepended do
        redefine_method :service do
          @service ||= begin
            raise KeyError, "storage service name should not be 'saas'" if service_name.to_s == 'saas'

            services.fetch(service_name) { |_| ActiveStorageSaas.service_resolver.call(self) } || global_service
          end
        end

        validate on: :save do
          errors.add(:service_name, :invalid) if service_name.to_s == 'saas'
        end
      end

      private

        def global_service
          self.class.service
        end

        def analyzer_class
          analyzers = service.class.respond_to?(:analyzers) ? service.class.analyzers : ActiveStorage.analyzers
          analyzers.detect { |klass| klass.accept?(self) } || ActiveStorage::Analyzer::NullAnalyzer
        end

        def validate_service_name_in_services
          ActiveStorageSaas.service_name_validator.call(service_name) || super
        end
    end
  end
end
