module Spree
  LineItem.class_eval do    

    alias_method :orig_update_price_from_modifier, :update_price_from_modifier

    def update_price_from_modifier(currency, opts)

      if currency
        self.currency = currency
        self.price = variant.price_in(currency).amount +
          variant.price_modifier_amount_in(currency, opts)
      else
        self.price = variant.price +
          variant.price_modifier_amount(opts)
      end

      area = opts['height'].to_i * opts['weight'].to_i
      perimeter = (opts['height'].to_i + opts['weight'].to_i)*2

      self.price = if area > 0
        area * self.price
      end      

      #logger.fatal "************* #{opts} ************"
      #logger.fatal "************* H=>#{opts['height']} ************"
      #logger.fatal "************* W=>#{opts['weight']} ************"
      #logger.fatal "************* AREA =>#{area} ************"
      #logger.fatal "************* PERIMETER =>#{perimeter} ************"
      #logger.fatal "************* PRICE =>#{variant.price} ************"
      #logger.fatal "************* TOTAL PRICE =>#{self.price} ************"

    end
  end
end