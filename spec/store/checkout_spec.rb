# frozen_string_literal: true

require './store/checkout'
require './store/discount'
require './store/product'
require 'json'

RSpec.describe Checkout do
  let(:rules_data) { JSON.parse(File.read('store/rules.json')) }
  let(:products_data) { JSON.parse(File.read('store/products.json')) }
  let(:products) do
    products_data.map { |pro| Product.new(code: pro['code'], name: pro['name'], price: pro['price']) }
  end

  subject(:checkout) { described_class.new(rules, products) }

  describe '#scan' do
    let(:rules) { [Discount.new(rules_data['rules'])] }

    it 'adds valid product successfully' do
      expect(checkout.scan('VOUCHER')).to eql(true)
    end

    it 'does not add invalid product' do
      expect(checkout.scan('VCHER')).to eql(false)
    end
  end

  describe '#show' do
    let(:rules) { [Discount.new(rules_data['rules'])] }

    context 'when items are present' do
      before { add_items_to_cart(%w[MUG MUG]) }

      it 'shows total values with items' do
        expect(checkout.show).to eql(['Items: MUG, MUG', 'Total: 15.0$'])
      end
    end

    context 'when no items are present' do
      let(:rules) { [] }

      it 'returns No items to checkout' do
        expect(checkout.show).to eql('No items to checkout')
      end
    end
  end

  describe '#total' do
    let(:rules) { [Discount.new(rules_data['rules'])] }

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
      expect(checkout.total).to eq(45.0)
    end

    it 'calculates total price correctly for example 4' do
      add_items_to_cart(%w[VOUCHER TSHIRT VOUCHER VOUCHER MUG TSHIRT TSHIRT])
      expect(checkout.total).to eq(37.5)
    end
  end

  def add_items_to_cart(item_codes)
    item_codes.each { |code| checkout.scan(code) }
  end
end
