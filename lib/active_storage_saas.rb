# frozen_string_literal: true

module ActiveStorageSaas
  class Error < StandardError; end

  mattr_accessor :service_resolver
  mattr_accessor :service_name_converter
  mattr_accessor :service_name_validator
  mattr_accessor :direct_upload_extra_blob_args

  require 'active_storage_saas/routes'
  require 'active_storage_saas/engine'
end
