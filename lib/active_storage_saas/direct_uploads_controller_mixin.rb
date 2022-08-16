module ActiveStorageSaas
  module DirectUploadsControllerMixin
    extend ActiveSupport::Concern

    included do
      prepend InstanceMethods
    end

    prepended do
      prepend InstanceMethods
    end

    module InstanceMethods
      def create
        blob = ActiveStorage::Blob.create!(blob_args)
        render json: direct_upload_json(blob)
      end

      def callback
        ActiveStorageSaas.direct_upload_callback.call(self)
      end

      private

        def blob_args
          super.merge(ActiveStorageSaas.direct_upload_extra_blob_args.call(self))
               .merge(service_name: ActiveStorageSaas.service_name_converter.call(self))
        end
    end
  end
end
