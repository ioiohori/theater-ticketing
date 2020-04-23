require "rails_helper"

describe AddsDiscountCodeToCart do

  let!(:code) { create(:discount_code, code: "TEST") }
  let(:user) { create(:user) }

  describe "adds a code to a new cart" do
    let(:workflow) { AddsDiscountCodeToCart.new(user: user, code: "TEST") }

    it "adds a code" do
      workflow.run
      cart = ShoppingCart.for(user: user)
      expect(cart.discount_code).to eq(code)
      expect(workflow).to be_a_success
    end
  end

  describe "it is no-op if the code does not exists" do
    let(:workflow) { AddsDiscountCodeToCart.new(user: user, code: "BANANA") }

    it "does not add discount code" do
      workflow.run
      cart = ShoppingCart.for(user: user)
      expect(cart.discount_code).to be_nil
      expect(workflow).to be_a_success
    end
  end

  describe "with an existing cart and code" do
    let!(:existing_code) { create(:discount_code, code: "EXISTING") }

    before(:example) do
      ShoppingCart.for(user:user).update(discount_code: existing_code)
    end

    context "with a real code" do
      let(:workflow) { AddsDiscountCodeToCart.new(user: user, code: "TEST") }

      it "overrides an existing code" do
        workflow.run
        cart = ShoppingCart.for(user: user)
        expect(cart.discount_code).to eq(code)
        expect(workflow).to be_a_success
      end
    end

    context "with a fake code" do
      let(:workflow) { AddsDiscountCodeToCart.new(user: user, code: "BANANA") }

      it "overrides an existing code" do
        workflow.run
        cart = ShoppingCart.for(user: user)
        expect(cart.discount_code).to be_nil
        expect(workflow).to be_a_success
      end
    end
  end
end
