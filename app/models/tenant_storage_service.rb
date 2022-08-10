class TenantStorageService < ApplicationRecord
  belongs_to :tenant, inverse_of: :storage_services

  store :service_options, coder: ActiveRecord::Coders::JSON
end
