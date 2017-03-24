Deface::Override.new(:virtual_path  => "spree/products/_cart_form",
                     :insert_after  => "div#product-price",
                     :partial       => "spree/products/area",
                     :name          => "area")