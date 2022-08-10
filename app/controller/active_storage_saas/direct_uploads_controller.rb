class ActiveStorageSaas::DirectUploadsController < ActiveStorageSaas::BaseController
  def create
    blob = ActiveStorage::Blob.create!(blob_args)
    render json: direct_upload_json(blob)
  end

  def callback
    raise NotImplementedError
  end

  private

    def blob_args
      blob_args = params.require(:blob).permit(:filename, :byte_size, :checksum, :content_type).to_h.symbolize_keys
      blob_args.merge! tenant: current_tenant, tenant_storage_service: current_tenant.storage_service
    end

    def direct_upload_json(blob)
      blob.as_json(root: false, methods: :signed_id, only: :signed_id)
          .merge(direct_upload: {
                   url: blob.service_url_for_direct_upload,
                   headers: blob.service_headers_for_direct_upload,
                   formData: blob.service_form_data_for_direct_upload
                 })
    end
end
