module Spree
  Order.class_eval do    

    alias_method :orig_find_line_item_by_variant, :find_line_item_by_variant

    def find_line_item_by_variant(variant, options = {})
      line_items.detect { |line_item|
                    line_item.variant_id == variant.id &&
                    line_item_options_match(line_item, options) &&
                    check_height_width_options(line_item, options)
                  }
    end

    def check_height_width_options(line_item, options)
      #puts "==================================================="
      #puts "********** CHECKING OPTIONS #{options} ***********"
      #puts "********** LINE ITEM ID #{line_item.id} ***********"
      #puts "********** LINE ITEM HEIGHT #{line_item.height.to_i} ***********"
      #puts "********** LINE ITEM WEIGHT #{line_item.width.to_i} ***********"
      #puts "==================================================="
      if options['height'].blank? && options['width'].blank?
        true
      else
        if options['height'].to_i == line_item.height.to_i && options['width'].to_i == line_item.width.to_i
          true
        else
          false
        end
      end
    end

  end
end