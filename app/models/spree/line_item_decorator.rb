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
      #self.price = 230979

      #area = if !opts[:height].blank? && !opts[:weight].blank?
      #  opts[:height] * opts[:weight]
      #else
      #  400
      #end
      logger.fatal "************* ERROR ************"
      logger.fatal "************* #{opts} ************"
      logger.fatal "************* H=>#{opts['height']} ************"
      logger.fatal "************* W=>#{opts['weight']} ************"
      area = opts['height'].to_i * opts['weight'].to_i
      perimeter = (opts['height'].to_i + opts['weight'].to_i)*2

      logger.fatal "************* AREA =>#{area} ************"
      logger.fatal "************* PERIMETER =>#{perimeter} ************"

      self.price = if area > 0
        area * variant.price
      else
        variant.price
      end

      logger.fatal "************* PRICE =>#{variant.price} ************"
      logger.fatal "************* TOTAL PRICE =>#{self.price} ************"

    end
  end
end