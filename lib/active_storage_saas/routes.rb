module ActiveStorageSaas
  module Routes
    # rubocop: disable Layout/LineLength
    def draw_active_storage_saas_routes(
      prefix: '/rails/active_storage',
      blobs_controller: 'active_storage/blobs',
      representations_controller: 'active_storage/representations',
      disk_controller: 'active_storage/disk',
      direct_uploads_controller: 'active_storage_saas/direct_uploads',
      **option_overrides
    )
      scope prefix do
        get '/blobs/:signed_id/*filename' => "#{blobs_controller}#show", as: :rails_service_blob
        get '/representations/:signed_blob_id/:variation_key/*filename' => "#{representations_controller}#show", as: :rails_blob_representation
        get  '/disk/:encoded_key/*filename' => "#{disk_controller}#show", as: :rails_disk_service
        put  '/disk/:encoded_token' => "#{disk_controller}#update", as: :update_rails_disk_service
        post '/direct_uploads' => "#{direct_uploads_controller}#create", as: :rails_direct_uploads
        match '/direct_uploads/callback/:signed_id' => "#{direct_uploads_controller}#callback", as: :rails_direct_upload_callback, via: %i[get post]
      end

      direct :rails_blob do |blob, options|
        route_for(:rails_service_blob, blob.signed_id, blob.filename, options)
      end

      resolve('ActiveStorage::Blob') { |blob, options| route_for(:rails_blob, blob, options.merge(option_overrides)) }
      resolve('ActiveStorage::Attachment') { |attachment, options| route_for(:rails_blob, attachment.blob, options.merge(option_overrides)) }

      direct :rails_representation do |representation, options|
        signed_blob_id = representation.blob.signed_id
        variation_key  = representation.variation.key
        filename       = representation.blob.filename

        route_for(:rails_blob_representation, signed_blob_id, variation_key, filename, options)
      end

      resolve('ActiveStorage::Variant') { |variant, options| route_for(:rails_representation, variant, options.merge(option_overrides)) }
      resolve('ActiveStorage::Preview') { |preview, options| route_for(:rails_representation, preview, options.merge(option_overrides)) }
    end
    # rubocop: enable Layout/LineLength
  end
end
