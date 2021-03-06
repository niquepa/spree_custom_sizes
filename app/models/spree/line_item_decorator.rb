module Spree
  LineItem.class_eval do    

    alias_method :orig_update_price_from_modifier, :update_price_from_modifier

    validates :job_name, presence: true

    has_many :finishing_line_items, :dependent => :destroy
    #accepts_nested_attributes_for :finishing_line_items

    def options=(options = {})
      return unless options.present?

      opts = options.dup # we will be deleting from the hash, so leave the caller's copy intact

      currency = opts.delete(:currency) || order.try(:currency)

      #Incluimos los valores de Ancho y Alto
      self.unit = options['unit'] if !options['unit'].blank?
      self.height = options['height'] if !options['height'].blank?
      self.width = options['width'] if !options['width'].blank?

      self.job_name = options['job_name'] if !options['job_name'].blank?
      if self.height > 0 and self.width > 0
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

      #area = opts['height'].to_i * opts['width'].to_i
      #perimeter = (opts['height'].to_i + opts['width'].to_i)*2
      #calc_area(opts)
      #calc_perimeter(opts)

      self.price = if self.area > 0
        (self.area/144) * self.price
        #self.name += "SIZE: #{self.height.to_i}x#{self.width.to_i}"
      end

      logger.fatal "************* CALCULANDO EL PRECIO =>#{self.price} ************"

      self.finishing_line_items.each do |fili|
        logger.fatal "************* FILI=>#{fili.id} =>#{fili.price_modifier} ************"
        self.price += fili.price_modifier
      end

      logger.fatal "************* DESPUES DE LOS FINISHINGS EL PRECIO =>#{self.price} ************"
      #logger.fatal "************* #{opts} ************"
      #logger.fatal "************* H=>#{opts['height']} ************"
      #logger.fatal "************* W=>#{opts['width']} ************"
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
      if self.unit == "ft" && (!self.height.blank? and !self.width.blank?)
        self.area = (self.height.to_i*self.width.to_i)*144
      else
        self.area = (self.height * self.width)
      end
    end

    def calc_perimeter
      if self.unit == "ft" && (!self.height.blank? and !self.width.blank?)
        self.perimeter = (self.height.to_i + self.width.to_i)*24
      else
        self.perimeter = (self.height+self.width)*2
      end
    end

    def name
      !self.height.blank? && !self.width.blank? ? "#{self.job_name} - " + variant.name + " - #{self.size}" : variant.name
    end

    def size
      "#{self.height.to_i}x#{self.width.to_i} #{self.unit}"
    end

  end
end