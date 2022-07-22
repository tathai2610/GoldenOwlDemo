require Rails.root.join('app', 'apis', 'ghn_client')
require 'json'

namespace :address_data do
  desc "Create data file for cities, district, wards"
  task create: :environment do
    address = []
    request = GhnClient.new
    province_response = request.get_province
  
    province_response["data"].each do |province|
      puts province["ProvinceName"] + " " + province["ProvinceID"].to_s
      district_response = request.get_district province["ProvinceID"]

      district_response["data"].each do |district|
        puts "  " + district["DistrictName"] + " " + district["DistrictID"].to_s
        ward_response = request.get_ward district["DistrictID"]
        if ward_response["data"].present?
          puts "    " + ward_response["data"].map { |ward| ward["WardName"] }.to_s
          district["wards"] = ward_response["data"]
        end
      end

      province["districts"] = district_response["data"]
    end

    File.open("data/vietnam_provinces_districts_wards.json", "w") do  |f|
      f.puts(province_response["data"].to_json)
    end
  end

end
