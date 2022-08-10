class ActiveStorageSaas::BaseController < ActiveStorage::BaseController
  unless method_defined?(:current_tenant)
    def current_tenant
      raise NotImplementedError
    end
  end
end
