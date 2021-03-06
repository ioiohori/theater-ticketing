require "rails_helper"

describe PreparesCartForPayPal, :vcr, :aggregate_failures do

  describe "successful credit card purchase", :vcr do
    let(:performance) { create(:performance, event: create(:event)) }
    let(:ticket_1) { create(:ticket, status: "waiting", price: Money.new(1500), performance: performance, payment_reference: "reference") }
    let(:ticket_2) { create(:ticket, status: "waiting", price: Money.new(1500), performance: performance, payment_reference: "reference") }
    let(:ticket_3) { create(:ticket, status: "unsold", performance: performance, payment_reference: "reference") }
    let(:user) { create(:user) }
  let(:discount_code) { nil }
  let(:discount_code_string) { nil }
  let(:shopping_cart) { create(:shopping_cart, user: user, discount_code: discount_code,
                               shipping_method: :electronic) }

  let(:attributes) { { user_id: user.id, price_cents: 3100, status: "created",
                       partials: { "ticket_cents": [1500, 1500],
                        "processing_fee_cents": 100 },
                       discount_code_id: nil,
                       shipping_address: nil, shipping_method: "electronic",
                       reference: a_truthy_value, payment_method: "paypal" } }

  let(:workflow) { PreparesCartForPayPal.new(user: user, purchase_amount_cents: 3100, expected_ticket_ids: "#{ticket_1.id} #{ticket_2.id}", payment_reference: "reference", shopping_cart: shopping_cart) }

    before(:example) do
      [ticket_1, ticket_2].each { |t| t.place_in_cart_for(user) }
    end

    it "updates the ticket status" do
      workflow.run
      [ticket_1, ticket_2, ticket_3].each(&:reload)
      expect(ticket_1).to be_pending
      expect(ticket_2).to be_pending
      expect(ticket_3).not_to be_pending
      expect(workflow.success).to be_truthy
      expect(workflow.payment_attributes).to match(attributes)
      expect(workflow.payment.payment_line_items.size).to eq(2)
      expect(workflow.redirect_on_success_url).to start_with("https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_express-checkout")
      expect(workflow.payment.response_id).to eq(workflow.pay_pal_payment.pay_pal_payment.id)
    end

    context "with discount code" do
      let(:workflow) { PreparesCartForPayPal.new(user: user, purchase_amount_cents: 2350,  expected_ticket_ids: "#{ticket_1.id} #{ticket_2.id}", payment_reference: "reference", shopping_cart: shopping_cart) }
      let(:discount_code_string) { "CODE" }
      let!(:discount_code) { create(:discount_code, percentage: 25, code: discount_code_string, minimum_amount: 0, maximum_discount: 0) }
      let(:attributes) { { user_id: user.id, price_cents: 2350, status: "created",
                           partials: { "ticket_cents": [1500, 1500],
                            "processing_fee_cents": 100,
                            "discount_cents": -750 },
                           shipping_address: nil, shipping_method: "electronic",
                           discount_code_id: discount_code.id,
                           reference: a_truthy_value, payment_method: "paypal" } }

      it "creates a transaction object" do
        workflow.run
        expect(workflow.payment_attributes).to match(attributes)
        expect(workflow.payment.payment_line_items.size).to eq(2)
      end
    end
  end
end
