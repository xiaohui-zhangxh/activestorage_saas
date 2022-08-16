# frozen_string_literal: true
require 'rails_helper'

RSpec.describe ActiveStorageSaas::Engine do
  context "ActiveStorageSaas" do
    subject(:active_storage_saas) { ActiveStorageSaas }
    it { expect(subject.service_resolver).to respond_to :call }
    it { expect(subject.service_name_converter).to respond_to :call }
    it { expect(subject.service_name_validator).to respond_to :call }
    it { expect(subject.direct_upload_extra_blob_args).to respond_to :call }
  end

  it { expect(ActiveStorage::DirectUploadsController.ancestors).to \
        include ActiveStorageSaas::DirectUploadsControllerMixin }
  it { expect(ActiveStorage::Blob.ancestors).to \
        include ActiveStorageSaas::BlobModelMixin }

end
