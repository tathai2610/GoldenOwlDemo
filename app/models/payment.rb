class Payment < ApplicationRecord
  VND_TO_USD_EXCHANGE_RATE = 23000

  enum status: { pending: 0, executing: 1, paid: 2, failed: 3 }
  
  belongs_to :order
end
