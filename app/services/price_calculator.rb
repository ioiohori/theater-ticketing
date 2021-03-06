class PriceCalculator

  attr_accessor :tickets, :discount_code, :shipping, :user, :address, :tax_id

  def initialize(tickets = [], discount_code = nil, shipping = :none,
                user: nil, address: nil, tax_id: nil, payment_type: nil)
    @tickets = tickets
    @discount_code = discount_code || NullDiscountCode.new
    @shipping = shipping
    @user = user
    @address = address
    @tax_id = tax_id
    @payment_type = payment_type
  end

  def processing_fee
    return Money.zero if @payment_type == "pay_pal"
    (subtotal - discount).positive? ? Money.new(100) : Money.zero
  end

  def shipping_fee
    return Money.zero if @payment_type == "pay_pal"

    case shipping.to_sym
    when :standard then Money.new(200)
    when :overnight then Money.new(1000)
    else
      Money.zero
    end
  end

  def subtotal
    tickets.map(&:price).sum
  end

  def breakdown
    result = { ticket_cents: tickets.map { |t| t.price_cents } }
    if processing_fee.nonzero?
      result[:processing_fee_cents] = processing_fee.cents
    end
    result[:discount_cents] = -discount.cents if discount.nonzero?
    result[:shipping_cents] = shipping_fee.cents if shipping_fee.nonzero?
    result[:sales_tax] = tax_calculator.itemized_taxes if sales_tax.nonzero?
    result
  end

  def tax_calculator
    @tax_calculator ||= TaxCalculator.new(user: user, cart_id: tax_id, address: address, items: tax_items)
  end

  def sales_tax
    return Money.zero if @payment_type == "pay_pal"
    return Money.zero if address.nil?
    tax_calculator.tax_amount
  end

  def tax_items
    items = [TaxCalculator::Item.create(:ticket, 1, subtotal - discount)]

    if processing_fee.nonzero?
      items << TaxCalculator::Item.create(:processing, 1, processing_fee)
    end

    if shipping_fee.nonzero?
      items << TaxCalculator::Item.create(:shipping, 1, shipping_fee)
    end
    items
  end

  def total_price
    base_price + processing_fee + shipping_fee + sales_tax
    # subtotal - discount + processing_fee + shipping_fee + sales_tax
  end

  def base_price
    checked_discount = @payment_type == "pay_pal" ? Money.zero : discount
    subtotal - checked_discount
  end

  def discount
    discount_code.discount_for(subtotal)
  end

  def affiliate_payment
    base_price * 0.05
  end

  def affiliate_application_fee
    total_price - affiliate_payment
  end
end
