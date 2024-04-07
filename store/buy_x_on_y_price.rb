# frozen_string_literal: true

# buy_x_on_y_price.rb
class BuyXOnYPrice
  def apply(group, rule)
    return unless group&.any? && group.count >= rule['threshold']

    on_price_item_count = rule['threshold'] - rule['on_price']
    selected_items = group.take(on_price_item_count)
    selected_items&.each { |item| item.price = 0 }
  end
end
