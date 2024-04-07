# frozen_string_literal: true

require 'json'
require './store/checkout'
require './store/discount'
require 'pry'

# main.rb
class Main
  def initialize
    read_discount_rules # read rules json and initialise discount.
    products = seed_products # insert data from json
    @checkout = Checkout.new([@rule_one], products) # initialised checkout with rules and products
    @store = @checkout.store # initialise store with the help of checkoout
  end

  def read_discount_rules
    rules_data = JSON.parse(File.read('store/rules.json'))
    @rule_one = Discount.new(rules_data['rules'])
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
    puts 'Please enter product codes separated by commas (e.g., VOUCHER, TSHIRT, MUG):'
    prompt
    codes = gets.chomp.split(',').map(&:strip)

    breakline
    added = []
    codes.each do |code|
      added << code if @checkout.scan(code)
    end
    puts "The products #{added.join(', ')} were added successfully" unless added.empty?
    puts "\n"
  end

  def total_cart_price
    @checkout.show # it will print item with price
  end

  def cli
    option = 0
    while option != 4
      puts <<~MENU
        Welcome to Store

        1. Product Inventory
        2. Add product to Cart
        3. Total (Checkout)
        4. Exit
      MENU

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
        puts 'Thank you for shopping'
      else
        puts 'Please select a correct option'
      end
    end
  end
end

obj = Main.new
obj.cli
