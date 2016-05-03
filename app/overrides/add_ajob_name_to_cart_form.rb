Deface::Override.new(:virtual_path  => "spree/products/_cart_form",
                     :insert_after  => "div#area",
                     :partial       => "spree/products/job_name",
                     :name          => "job_name")