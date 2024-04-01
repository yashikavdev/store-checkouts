# frozen_string_literal: true

# store/one_on_one_discount_rule.rb
class OneOnOneDiscountRule
  def initialize(code)
    @code = code
  end

  def apply(items)
    selected_items = items.select { |i| i.code == @code }
    selected_items.each do |item|
      item.price = 0
    end
  end
end
