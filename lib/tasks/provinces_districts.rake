require 'json'

namespace :provinces_districts do
  desc "Import Vietnam provinces and districts data"
  task import: :environment do
    file = File.read('data/vietnam_provinces_districts.json')
    data = JSON.parse(file)
    
    data.each do |city|
      c = City.create(name: city['name'])

      city['districts'].each do |district|
        d = District.create(name: district['name'], city: c)

        district['wards'].each do |ward|
          Ward.create(name: ward['name'], district: d)
        end
      end
    end
  end

end
