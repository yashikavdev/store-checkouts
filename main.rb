# frozen_string_literal: true

require 'json'
require './store/checkout'
require './store/discount_rule'
require './store/buy_x_on_y_price'
require './store/one_on_one_discount_rule'
require 'pry'

# main.rb
class Main
  def initialize
    @rule_one = BuyXOnYPrice.new('VOUCHER')
    @rule_two = DiscountRule.new('TSHIRT', 3, 1.0)
    @rule_three = OneOnOneDiscountRule.new('MUG')
    products = seed_products
    @checkout = Checkout.new([@rule_one, @rule_two], products)
    @store = @checkout.store
  end

  def seed_products
    file = File.read('store/products.json')
    JSON.parse(file).map { |pro| Product.new(code: pro['code'], name: pro['name'], price: pro['price']) }
  end

  def prompt
    print '> '
  end

  def breakline
    puts "\n"
  end

  def all_products
    @store.list
  end

  def add_product
    puts 'Please enter code: '
    prompt
    code = gets.chomp

    breakline
    puts @checkout.scan(code) ? 'The product was added successfully' : 'This product does not exist'
  end

  def total_cart_price
    @checkout.show
  end

  def cli
    option = 0
    while option != 4
      puts '
        Welcome to Store

        1. Product Inventory
        2. Add product to Cart
        3. Total ( Checkout )
        4. Exit
      '
      prompt

      option = gets.chomp.to_i
      breakline

      case option
      when 1
        puts all_products
      when 2
        add_product
      when 3
        puts total_cart_price
      when 4
        puts 'Thankyou for shopping'
      else
        puts 'Please select a correct option'
      end
    end
  end
end

obj = Main.new
obj.cli
