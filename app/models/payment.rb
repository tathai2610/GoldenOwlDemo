class Payment < ApplicationRecord
  enum status: { pending: 0, executing: 1, paid: 2, failed: 3 }
  
  belongs_to :order
end
