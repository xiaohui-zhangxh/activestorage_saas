RSpec.describe TenantStorageService, type: :model do
  it { is_expected.to belong_to(:tenant).inverse_of(:storage_services) }
end
