class AddressesController < ApplicationController
  before_action :set_city, only: :get_districts
  before_action :set_district, only: :get_wards

  def get_districts
    @districts = @city.districts

    respond_to do |format|
      format.json { render json: @districts }
    end
  end

  def get_wards
    @wards = @district.wards

    respond_to do |format|
      format.json { render json: @wards }
    end
  end

  private

  def set_city
    @city = City.find_by(shipping_code: params[:city_id])
  end

  def set_district
    @district = District.find_by(shipping_code: params[:district_id])
  end
end
