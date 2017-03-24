module Spree
  OrderContents.class_eval do

    alias_method :orig_add, :add

    def add(variant, quantity = 1, options = {})
      timestamp = Time.current

      puts " ================================================================= "
      puts " ===========================CONTENTS ADD========================== "
      puts " ******* #{options} ********"
      puts " ================================================================= "
      puts " ================================================================= "

      line_item = add_to_line_item(variant, quantity, options)
      options[:line_item_created] = true if timestamp <= line_item.created_at
      after_add_or_remove(line_item, options)
    end

    def add_to_line_item(variant, quantity, options = {})
      line_item = grab_line_item_by_variant(variant, false, options)

      puts " ================================================================= "
      puts " ===================CONTENTS ADD TO LINE========================== "
      puts " ******* #{options} ********"
      puts " ================================================================= "
      puts " ================================================================= "

      if line_item
        line_item.quantity += quantity.to_i
        line_item.currency = currency unless currency.nil?
      else

        opts = { currency: order.currency }.merge ActionController::Parameters.new(options).
                                            permit(PermittedAttributes.line_item_attributes)

        puts " ================================================================= "
        puts " ===================CONTENTS ADD TO LINE ELSE===================== "
        puts " ******* OPTS #{opts} ********"
        puts " ******* PERMITTED #{PermittedAttributes.line_item_attributes} ********"
        puts " ================================================================= "
        puts " ================================================================= "

        line_item = order.line_items.new(quantity: quantity,
                                          variant: variant,
                                          options: opts)
      end
      line_item.target_shipment = options[:shipment] if options.has_key? :shipment

      line_item.save!
      puts " ================================================================= "
      puts " ===============================FINAL============================= "
      puts " ================================================================= "      
      
      line_item
    end

    def grab_line_item_by_variant(variant, raise_error = false, options = {})
      line_item = order.find_line_item_by_variant(variant, options)

      if !line_item.present? && raise_error
        raise ActiveRecord::RecordNotFound, "Line item not found for variant #{variant.sku}"
      end

      line_item
    end

  end
end