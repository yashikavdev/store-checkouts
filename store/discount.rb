# frozen_string_literal: true

require_relative 'buy_x_on_y_price'
require_relative 'bulk_discount'

# discount.rb
class Discount
  def initialize(rules)
    @rules = rules
  end

  def apply(cart)
    items = cart.items
    return if filtered_grouped_items(items).empty? # check items shuld not be empty

    products = items.map(&:clone) # keeping copy of items to use in bulk discount
    apply_discounts(items, products) # call appropriate discount(bulk, buyxony)
    apply_best_discount(products, items, cart) #return max discout price's item
  end

  private

  def apply_discounts(items, products)
    @rules.each do |rule|
      grouped_items = items.group_by(&:code) # group by code
      new_group = grouped_items[rule['code']] # match group have code which rule also have
      apply_rule(new_group, items, products, rule)
    end
  end

  def apply_rule(new_group, items, products, rule)
    if rule['type'] == 'BulkDiscount'
      BulkDiscount.new.apply(new_group, items, rule, products)
    else
      BuyXOnYPrice.new.apply(new_group, rule)
    end
  end

  def apply_best_discount(products, items, cart)
    sum_of_prices_products = products&.sum(&:price)
    sum_of_prices_items = items&.sum(&:price)

    sum_of_prices_products > sum_of_prices_items ? items : (cart.items = products)
  end

  def filtered_grouped_items(items)
    items.group_by(&:code).select { |_code, items| items.size > 1 }
  end
end
