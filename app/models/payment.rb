class Payment < ApplicationRecord
  enum status: { pending: 0, executing: 1, paid: 2, failed: 3 }
  
  belongs_to :order

  def set_paid 
    self.status = Payment.statuses[:paid]
  end

  def set_executing 
    self.status = Payment.statuses[:executing]
  end
  
  def set_failed 
    self.satus = Payment.statuses[:failed]
  end
end
