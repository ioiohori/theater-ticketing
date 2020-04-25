class TaxValidityException < StandardError

  attr_accessor :message, :payment_id, :expected_taxes, :paid_taxes

  def initialize(message = nil, payment_id:, expected_taxes:, paid_taxes:)
    super(message)
    @payment_id = payment_id
    @expected_taxes = expected_taxes
    @paid_taxes = paid_taxes
    puts "[TaxValidityException] payment_id: #{payment_id}"
    puts "[TaxValidityException] expected_taxes #{expected_taxes}"
    puts "[TaxValidityException] paid_taxes: #{paid_taxes}"
  end
end
