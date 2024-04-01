# frozen_string_literal: true

require_relative 'store'
require_relative 'item'
require_relative 'cart'

# store/checkout.rb
class Checkout
  attr_reader :store, :cart

  def initialize(pricing_rules, products)
    @rules = pricing_rules
    @store = Store.new('My Store', products)
    @cart = Cart.new
    @valid_codes = @store.valid_codes
  end

  def scan(code)
    return false unless @valid_codes.include?(code)

    product = @store.find(code)
    item = Item.new(product.code, product.price)
    @cart.add(item)

    true
  end

  def show
    items = @cart.items.map(&:code).join(', ')

    return 'No items to checkout' unless items.size.positive?

    ["Items: #{items}", "Total: #{total}$"]
  end

  def total
    @rules.each { |rule| rule.apply(@cart.items) }
    @cart.items.inject(0.0) { |total, item| total + item.price }
  end
end
