RSpec.describe ActiveStorage::Blob, type: :model do
  it { is_expected.to belong_to(:tenant) }
  it { is_expected.to belong_to(:tenant_storage_service).optional(true) }

  context "instance" do
    subject(:blob) { described_class.new }

    let(:saas_service) { ActiveStorage::Service::SaasService.new }

    before do
      @service_backup = described_class.service
      described_class.service = saas_service
    end

    after do
      described_class.service = @service_backup
    end

    it do
      expect(saas_service).to receive(:url_for_direct_upload)
      blob.service_url_for_direct_upload
    end
  end
end
