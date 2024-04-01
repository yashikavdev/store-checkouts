# frozen_string_literal: true

# buy_x_on_y_price.rb
class BuyXOnYPrice
  def initialize(code)
    @code = code
  end

  def apply(items)
    selected_items = items.select { |i| i.code == @code }
    return unless selected_items.size >= 2

    selected_items.each_slice(2) do |_item, item_free|
      item_free.price = 0 unless item_free.nil?
    end
  end
end
