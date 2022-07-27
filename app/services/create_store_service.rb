class CreateStoreService < ApplicationService
  def initialize(shop_registration)
    @shop_registration = shop_registration
  end

  def call 
    ActiveRecord::Base.transaction do 
      raise ActiveRecord::RecordInvalid unless @shop_registration.save
      response = GhnClient.new.create_store(@shop_registration.shop)
      raise ActiveRecord::RecordInvalid unless response["code"] == 200
      @shop_registration.shop.update!(code: response["data"]["shop_id"])
    end
  end
end
