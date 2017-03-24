Deface::Override.new(:virtual_path  => "spree/orders/_line_item",
                     :insert_after  => "[data-hook='line_item_description']",
                     :partial       => "spree/orders/finishings",
                     :name          => "finishings")