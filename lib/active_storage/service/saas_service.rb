require 'ruby2_keywords'
module ActiveStorage
  class Service
    # # config/storage.yml
    # saas:
    #   service: Saas
    #   default_service: qinium
    #   url_expires_in: 300
    # qinium:
    #   service: Qinium
    #   access_key:
    #   secret_key:
    #   bucket:
    #   put_policy_options:
    #     expires_in: 3600
    class SaasService < Service
      attr_reader :blob, :options

      def initialize(options)
        super()
        @blob = options.delete(:blob)
        @options = options
      end

      Service.public_instance_methods(false).each do |name|
        next if name.in?(%i[name=])

        define_method name do |*args, &block|
          service.public_send(name, *args, &block)
        end
        ruby2_keywords name
      end

      def name=(_)
        # do nothing, name should be service.name
      end

      redefine_method :url_expires_in do
        @options.fetch(:url_expires_in, 5.minutes)
      end

      ruby2_keywords def method_missing(name, *args, &block)
        service.public_send(name, *args, &block)
      end

      def respond_to_missing?(method, _include_all)
        service.respond_to?(method)
      end

      def http_method_for_direct_upload
        service.http_method_for_direct_upload if service.respond_to?(:http_method_for_direct_upload)
      end

      def http_response_type_for_direct_upload
        service.http_response_type_for_direct_upload if service.respond_to?(:http_response_type_for_direct_upload)
      end

      def form_data_for_direct_upload(key, expires_in:, content_type:, content_length:, checksum:)
        if service.respond_to?(:form_data_for_direct_upload)
          service.form_data_for_direct_upload key,
                                              expires_in: expires_in,
                                              content_type: content_type,
                                              content_length: content_length,
                                              checksum: checksum
        else
          {}
        end
      end

      def analyzers
        service_class = service.class
        service_class.respond_to?(:analyzers) ? service_class.analyzers : []
      end

      def service
        @service ||= (blob && ActiveStorageSaas.service_resolver.call(blob)) || default_service
      end

      def default_service
        @default_service ||= ActiveStorage::Blob.services.fetch(@options[:default_service])
      end
    end
  end
end
