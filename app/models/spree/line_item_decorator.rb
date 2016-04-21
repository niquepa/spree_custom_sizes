module Spree
  LineItem.class_eval do    

    alias_method :orig_update_price_from_modifier, :update_price_from_modifier

    def update_price_from_modifier(currency, opts)
      #if currency
      #  self.currency = currency
      #  self.price = variant.price_in(currency).amount +
      #    variant.price_modifier_amount_in(currency, opts)
      #else
      #  self.price = variant.price +
      #    variant.price_modifier_amount(opts)
      #end
      self.price = 230979
    end
  end
end