# frozen_string_literal: true

# store/item.rb
class Item
  attr_reader :code
  attr_accessor :price

  def initialize(code, price)
    @code = code
    @price = price
  end
end
