# frozen_string_literal: true
require 'rails_helper'

RSpec.describe ActiveStorageSaas do
  it { is_expected.to respond_to :service_resolver }
  it { is_expected.to respond_to :service_resolver= }
  it { is_expected.to respond_to :service_name_converter }
  it { is_expected.to respond_to :service_name_converter= }
  it { is_expected.to respond_to :service_name_validator }
  it { is_expected.to respond_to :service_name_validator= }
  it { is_expected.to respond_to :direct_upload_extra_blob_args }
  it { is_expected.to respond_to :direct_upload_extra_blob_args= }
end
