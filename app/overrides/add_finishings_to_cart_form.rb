Deface::Override.new(:virtual_path  => "spree/products/_cart_form",
                     :insert_after  => "div#job-name",
                     :partial       => "spree/products/finishings",
                     :name          => "finishings")