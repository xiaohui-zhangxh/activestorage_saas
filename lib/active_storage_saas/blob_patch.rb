module ActiveStorageSaas
  module BlobPatch
    extend ActiveSupport::Concern

    included do
      belongs_to :tenant, class_name: ActiveStorageSaas.tenant_class_name # rubocop: disable Rails/ReflectionClassName
      belongs_to :tenant_storage_service, optional: true

      redefine_method :service do
        class_service = self.class.service
        if class_service.is_a?(ActiveStorage::Service::SaasService)
          @service ||= ActiveStorage::Service::SaasService.new(class_service.options.merge(blob: self))
        else
          class_service
        end
      end
    end

    # support sending data from form instead of headers
    def service_form_data_for_direct_upload(expires_in: service.url_expires_in)
      return {} unless service.respond_to?(:form_data_for_direct_upload)

      service.form_data_for_direct_upload(key,
                                          expires_in: expires_in,
                                          content_type: content_type,
                                          content_length: byte_size,
                                          checksum: checksum)
    end

    private

      def saas_service?
        service.is_a?(ActiveStorage::Service::SaasService)
      end

      def analyzer_class
        analyzers = saas_service? ? service.analyzers : ActiveStorage.analyzers
        analyzers.detect { |klass| klass.accept?(self) } || ActiveStorage::Analyzer::NullAnalyzer
      end
  end
end
