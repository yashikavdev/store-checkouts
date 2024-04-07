# frozen_string_literal: true

# bulk_discount.rb
class BulkDiscount
  def apply(new_group, _items, rule, products)
    return unless new_group&.any? && new_group.count >= rule['threshold']

    products.each { |item| item.price -= rule['discounted_price'] }
  end
end
