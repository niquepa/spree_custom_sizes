module Spree
  OrdersController.class_eval do
    
    def populate
      order    = current_order(create_order_if_necessary: true)
      variant  = Spree::Variant.find(params[:variant_id])
      quantity = params[:quantity].to_i
      options  = params[:options] || {}
      finishing_line_items = params[:finishing_line_items] || []

      #logger.fatal " OPTIONS OPTIONS OPTIONS OPTIONS OPTIONS OPTIONS OPTIONS"
      #logger.fatal " OPTIONS OPTIONS OPTIONS OPTIONS OPTIONS OPTIONS OPTIONS"
      #logger.fatal " ******* #{options} ********"
      #logger.fatal " ******* #{finishing_line_items} ********"
      #logger.fatal " OPTIONS OPTIONS OPTIONS OPTIONS OPTIONS OPTIONS OPTIONS"
      #logger.fatal " OPTIONS OPTIONS OPTIONS OPTIONS OPTIONS OPTIONS OPTIONS"

      # 2,147,483,647 is crazy. See issue #2695.
      if quantity.between?(1, 2_147_483_647)
        begin
          line_item = order.contents.add(variant, quantity, options)
          #logger.fatal "*****************"
          #logger.fatal "*****************"
          #logger.fatal " LINE ITEM => #{line_item.id} 9999999"
          #logger.fatal "*****************"
          #logger.fatal "*****************"

          params.permit!

          finishing_line_items.each do |finish_item|
            fi = Spree::Finishing.find(finish_item[:finishing_id])
            if !fi.is_parent?
              fili = Spree::FinishingLineItem.new(finish_item)
              fili.line_item = line_item
              fili.save
            end
          end
          #logger.fatal " CREADOS LOS FINISHINGS => #{line_item.id} 9999999"
          line_item = Spree::LineItem.find(line_item.id)
          line_item.update_price_from_modifier(nil,nil)
          line_item.save
          #logger.fatal " ACTUALIZADO EL PRECIO DE FINISHINGS => #{line_item.price.to_s} 9999999"
        rescue ActiveRecord::RecordInvalid => e
          error = e.record.errors.full_messages.join(", ")
        end
      else
        error = Spree.t(:please_enter_reasonable_quantity)
      end

      if error
        flash[:error] = error
        redirect_back_or_default(spree.root_path)
      else
        respond_with(order) do |format|
          format.html { redirect_to cart_path }
        end
      end
    end

  end

  def finishing_line_items_params
    params.require(:finishing_line_items).permit(:location, :finishing_id)
  end
end