# frozen_string_literal: true

require './store/checkout'
require './store/discount_rule'
require './store/buy_x_on_y_price'
require './store/one_on_one_discount_rule'

RSpec.describe Checkout do
  let(:rule_one) { BuyXOnYPrice.new('VOUCHER') }
  let(:rule_two) { DiscountRule.new('TSHIRT', 3, 1.0) }
  let(:rule_three) { FreeItemRule.new('MUG') }
  let(:products) do
    [
      Product.new(code: 'VOUCHER', name: 'Voucher', price: 5.0),
      Product.new(code: 'TSHIRT', name: 'T-Shirt', price: 20.0),
      Product.new(code: 'MUG', name: 'Mug', price: 7.50)
    ]
  end

  subject(:checkout) { described_class.new([rule_one, rule_two], products) }

  describe '#scan' do
    it 'adds valid product successfully' do
      expect(checkout.scan('VOUCHER')).to eql(true)
    end

    it 'does not add invalid product' do
      expect(checkout.scan('VCHER')).to eql(false)
    end
  end

  describe '#show' do
    context 'when items are present' do
      before { add_items_to_cart(%w[MUG MUG]) }

      it 'shows total values with items' do
        expect(checkout.show).to eql(['Items: MUG, MUG', 'Total: 15.0$'])
      end
    end

    context 'when no items are present' do
      it 'returns No items to checkout' do
        expect(checkout.show).to eql('No items to checkout')
      end
    end
  end

  describe '#total' do
    it 'calculates total price correctly for example 1' do
      add_items_to_cart(%w[VOUCHER TSHIRT MUG])
      expect(checkout.total).to eq(32.50)
    end

    it 'calculates total price correctly for example 2' do
      add_items_to_cart(%w[VOUCHER TSHIRT VOUCHER])
      expect(checkout.total).to eq(25.00)
    end

    it 'calculates total price correctly for example 3' do
      add_items_to_cart(%w[TSHIRT TSHIRT TSHIRT VOUCHER TSHIRT])
      expect(checkout.total).to eq(81.00)
    end

    it 'calculates total price correctly for example 4' do
      add_items_to_cart(%w[VOUCHER TSHIRT VOUCHER VOUCHER MUG TSHIRT TSHIRT])
      expect(checkout.total).to eq(74.50)
    end
  end

  def add_items_to_cart(item_codes)
    item_codes.each { |code| checkout.scan(code) }
  end
end
