class CashPurchasesCart < PreparesCart

  def update_tickets
    tickets.each(&:purchased!)
  end

  def on_success
    @success = true
    NotifyTaxCloudJob.perform_later(payment) if payment.shipping_address.present?
  end

  def payment_attributes
    super.merge(
      payment_method: "cash", status: "succeeded",
      administrator_id: user.id)
  end

  def pre_purchase_valid?
    raise UnauthorizedPurchaseException.new(user: user) unless user.admin?
    true
  end

  def on_failure
    unpurchase_tickets
  end
end
