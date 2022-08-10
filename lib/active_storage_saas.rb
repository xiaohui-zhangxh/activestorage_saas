# frozen_string_literal: true

module ActiveStorageSaas
  class Error < StandardError; end

  mattr_accessor :tenant_class_name, default: 'Tenant'

  require 'active_storage_saas/routes'
  require 'active_storage_saas/blob_patch'
  require 'active_storage_saas/engine'
end
