
RSpec.describe Tenant, type: :model do
  it { is_expected.to belong_to(:storage_service).class_name('TenantStorageService').inverse_of(:tenant).with_foreign_key(:tenant_storage_service_id).optional(true) }
  it { is_expected.to have_many(:storage_services).class_name('TenantStorageService').dependent(:restrict_with_error).inverse_of(:tenant) }
  it { is_expected.to have_one_attached(:logo) }
end
