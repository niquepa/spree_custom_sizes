Deface::Override.new(:virtual_path => "spree/checkout/_delivery",
                     :replace_contents  => "[data-hook='stock-contents']",
                     :partial           => "spree/checkout/line_items",
                     :name              => "shipment_manifesto")