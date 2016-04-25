module Spree
  LineItem.class_eval do    

    alias_method :orig_update_price_from_modifier, :update_price_from_modifier

    def options=(options = {})
      return unless options.present?

      opts = options.dup # we will be deleting from the hash, so leave the caller's copy intact

      currency = opts.delete(:currency) || order.try(:currency)

      #Incluimos los valores de Ancho y Alto
      self.height = options['height'] if !options['height'].blank?
      self.weight = options['weight'] if !options['weight'].blank?
      if self.height > 0 and self.weight > 0
        self.calc_area 
        self.calc_perimeter
      end

      update_price_from_modifier(currency, opts)
      assign_attributes opts
    end

    def update_price_from_modifier(currency, opts)

      if currency
        self.currency = currency
        self.price = variant.price_in(currency).amount +
          variant.price_modifier_amount_in(currency, opts)
      else
        self.price = variant.price +
          variant.price_modifier_amount(opts)
      end

      #area = opts['height'].to_i * opts['weight'].to_i
      #perimeter = (opts['height'].to_i + opts['weight'].to_i)*2
      #calc_area(opts)
      #calc_perimeter(opts)

      self.price = if self.area > 0
        self.area * self.price
      end      

      #logger.fatal "************* #{opts} ************"
      #logger.fatal "************* H=>#{opts['height']} ************"
      #logger.fatal "************* W=>#{opts['weight']} ************"
      #logger.fatal "************* AREA =>#{area} ************"
      #logger.fatal "************* PERIMETER =>#{perimeter} ************"
      #logger.fatal "************* PRICE =>#{variant.price} ************"
      #logger.fatal "************* TOTAL PRICE =>#{self.price} ************"

    end

    def update_price
      #self.price = variant.price_including_vat_for(tax_zone: tax_zone)
      price_options = { tax_zone: order.tax_zone }
      options = price_options.merge(tax_category: variant.tax_category)
      self.price = Spree::Price.first.gross_amount(self.price, options)
      logger.fatal "************* TOTAL PRICE =>#{self.price} ************"
      logger.fatal "************* TOTAL PRICE =>#{self.price} ************"
      logger.fatal "************* TOTAL PRICE =>#{self.price} ************"
      logger.fatal "************* TOTAL PRICE =>#{self.price} ************"
      logger.fatal "************* TOTAL PRICE =>#{self.price} ************"
      logger.fatal "************* TOTAL PRICE =>#{self.price} ************"
    end

    def calc_area
      self.area = self.height.to_i * self.weight.to_i if (!self.height.blank? and !self.weight.blank?)
    end

    def calc_perimeter
      self.perimeter = (self.height.to_i + self.weight.to_i)*2 if (!self.height.blank? and !self.weight.blank?)
    end

  end
end