# frozen_string_literal: true

# cart.rb
class Cart
  attr_accessor :items

  def initialize
    @items = []
  end

  def add(item)
    items << item
  end

  def remove(item)
    items.delete(item)
  end
end
