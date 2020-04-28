require "rails_helper"

describe StripeCharge, :vcr do

  describe "success", :aggregate_failures do
    let(:payment) { build_stubbed(:payment, price: Money.new(3000),
                                  reference: Payment.generate_reference) }
    let(:token) { StripeToken.new(
      credit_card_number: "4242424242424242", expiration_month: "12",
      expiration_year: Time.zone.now.year + 1, cvc: "123") }

    context "without an affiliate fee" do
      it "calls stripe to get a charge" do
        charge = StripeCharge.new(token: token, payment: payment)
        charge.charge
        expect(charge.response.id).to start_with("ch")
        expect(charge.response.amount).to eq(3000)
        expect(charge).to be_a_success
      end
    end

    # context "with an affiliate fee" do
    #   let(:user) { create(:user) }
    #   let(:affiliate_user) { create(:user, email: "affiliate_user@ex.com") }
    #   let(:affiliate_workflow) { AddsAffiliateAccount.new(user: affiliate_user) }
    #   let(:affiliate) { affiliate_workflow.affiliate }
    #   let(:payment) { Payment.create(user_id: user.id, price_cents: 3000, status: "created",
    #                                  reference: Payment.generate_reference, payment_method: "stripe") }

    #   before(:example) do
    #     affiliate_workflow.run
    #     payment.update(affiliate_id: affiliate.id, affiliate_payment_cents: 125)
    #   end

    #   it "calls stripe to get a charge" do
    #     charge = StripeCharge.new(token: token, payment: payment)
    #     expect(charge.charge_parameters).to match(amount: payment.price_cents, currency: "usd",
    #                                                sounce: token.id, description: "",
    #                                                destination: affiliate.stripe_id, application_fee: 2875,
    #                                                metadata: { reference: payment.reference })
    #     charge.charge
    #     expect(charge.response.id).to start_with("ch")
    #     expect(charge.response.amount).to eq(3000)
    #     expect(charge).to be_a_success
    #   end
    # end
  end

  describe "failure" do
    let(:payment) { build_stubbed(:payment, price: Money.new(3000),
                                  reference: Payment.generate_reference) }
    let(:token) { StripeToken.new(
      credit_card_number: "4000000000000002", expiration_month: "12",
      expiration_year: Time.zone.now.year + 1, cvc: "123") }

    it "handles failure" do
      charge = StripeCharge.new(token: token, payment: payment)
      charge.charge
      expect(charge.response).to be_nil
      expect(charge).not_to be_a_success
    end
  end
end
