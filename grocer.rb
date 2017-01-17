def consolidate_cart(cart)
  new_hash = {}

  cart.each do |food_hash|
    food_hash.each do |veggie, info_hash|
      if new_hash.has_key?(veggie)
        new_hash[veggie][:count] += 1
      else
        new_hash[veggie] = info_hash
        new_hash[veggie][:count] = 1
      end
    end
  end
  new_hash
end


def apply_coupons(cart, coupons)
  coupons.each do |coupon_hash|
    food = coupon_hash[:item]

    if cart.has_key?(food)
      num = cart[food][:count]
      coupon_num = num / coupon_hash[:num]
      remaining_num = num % coupon_hash[:num]

      if coupon_num > 0
        cart[food][:count] = remaining_num
        cart["#{food} W/COUPON"] = {
          :price => coupon_hash[:cost],
          :clearance => cart[food][:clearance],
          :count => coupon_num }
        end
      end
    end
    cart
end


def apply_clearance(cart)
  cart.each do |food, info_hash|
      if cart[food][:clearance] == true
        cart[food][:price] = (cart[food][:price] * 0.8).round(2)
    end
  end
end

def checkout(cart, coupons)
  total = 0

  cart_consolidated = consolidate_cart(cart)
  applied_coupons = apply_coupons(cart_consolidated, coupons)
  clearenced = apply_clearance(applied_coupons)

  array = cart_consolidated.collect do |food, info|
    info[:price] * info[:count]
end

  array.each do |value|
    total += value
  end

  if total >= 100
    total = (total * 0.9).round(2)
  end
  total
end
