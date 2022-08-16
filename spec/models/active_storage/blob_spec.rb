require 'rails_helper'

# qinium:
#   service: Qinium
#   access_key: <%= ENV['STORAGE_QINIU_ACCESS_KEY'] %>
#   secret_key: <%= ENV['STORAGE_QINIU_SECRET_KEY'] %>
#   bucket: <%= ENV['STORAGE_QINIU_BUCKET'] %>
#   protocol: <%= ENV['STORAGE_QINIU_PROTOCOL'] %>
#   domain: <%= ENV['STORAGE_QINIU_DOMAIN'] %>
#   put_policy_options:
#     expires_in: 3600

# saas:
#   service: Saas
#   default_service: qinium
#   url_expires_in: 86400
#   access_key_id: <%= Rails.application.credentials.dig(:aws, :access_key_id) %>
#   secret_access_key:

RSpec.describe ActiveStorage::Blob, type: :model do
  let(:storage_configs) do
    {
      local_a: {
        service: 'Disk',
        root: Rails.root.join('storage/a')
      },
      local_b: {
        service: 'S3',
        bucket: 'bucket_b',
        region: 'us-east-1',
        access_key_id: 'xx',
        secret_access_key: 'xx'
      },
      local_c: {
        service: 'S3',
        bucket: 'bucket_b',
        region: 'us-east-1',
        access_key_id: 'xx',
        secret_access_key: 'xx'
      },
      saas: {
        service: 'Saas',
        default_service: :local_c
      }
    }
  end

  before do
    ActiveStorage::Blob.services = ActiveStorage::Service::Registry.new(storage_configs)
    ActiveStorage::Blob.service = ActiveStorage::Blob.services.fetch(storage_service_name)
  end

  context "local_a service as default" do
    let(:storage_service_name) { :local_a }
    it { expect(ActiveStorage::Blob.service).to be_instance_of ActiveStorage::Service::DiskService }
    it { expect(subject.service).to be_instance_of ActiveStorage::Service::DiskService }
    it { expect(subject.service_name).to eq 'local_a' }

    it do
      instance = ActiveStorage::Blob.new(service_name: 'local_b')
      expect(instance.service).to be_instance_of ActiveStorage::Service::S3Service
      expect(instance.service_name).to eq 'local_b'
    end

    it do
      instance = ActiveStorage::Blob.new(service_name: 'saas')
      expect { instance.service }.to raise_error "storage service name should not be 'saas'"
    end
  end

  context "saas service as default" do
    let(:storage_service_name) { :saas }
    it { expect(ActiveStorage::Blob.service).to be_instance_of ActiveStorage::Service::SaasService }
    it { expect(subject.service).to be_instance_of ActiveStorage::Service::S3Service }
    it { expect(subject.service_name).to eq 'local_c' }

    it do
      storage_root = Rails.root.join('storage/saas_a').to_s
      storage_service_config = StorageServiceConfiguration.create(service_name: 'local_a', service_options: { root: storage_root })
      expect(storage_service_config.to_service_name).not_to eq 'local_a'
      instance = ActiveStorage::Blob.new(service_name: storage_service_config.to_service_name)
      expect(instance.service).to be_instance_of ActiveStorage::Service::DiskService
      expect(instance.service.root).to eq storage_root
      expect(instance.service.name).to eq storage_service_config.to_service_name
    end
  end

  # context "instance" do
  #   subject(:blob) { described_class.new(service_name: 'saas') }

  #   let(:saas_service) { ActiveStorage::Service::SaasService.new }

  #   before do
  #     @service_backup = described_class.service
  #     described_class.service = saas_service
  #   end

  #   after do
  #     described_class.service = @service_backup
  #   end

  #   it do
  #     expect(saas_service).to receive(:url_for_direct_upload)
  #     blob.service_url_for_direct_upload
  #   end
  # end
end
