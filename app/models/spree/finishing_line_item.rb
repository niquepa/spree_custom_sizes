module Spree
  class FinishingLineItem < ActiveRecord::Base

    belongs_to :line_item
    belongs_to :finishing

    validates :price_multiplier, numericality: true
    validates :price_modifier, numericality: true
    validates :quantity, numericality: true

    before_validation :copy_price_multiplier
    before_validation :copy_width_height
    before_validation :calc_quantity
    before_validation :calc_price_modifier

    def init
      self.frequency ||= 1
    end

    def copy_price_multiplier
      self.price_multiplier = finishing.price_multiplier
    end

    def copy_width_height
      self.width = line_item.unit == "ft" ? line_item.width : (line_item.width/12).ceil
      self.height = line_item.unit == "ft" ? line_item.height : (line_item.height/12).ceil
    end

    def calc_quantity
      self.quantity = location_multiplier * frequency
    end

    def calc_price_modifier
      self.price_modifier = self.quantity * self.price_multiplier
    end

    def location_multiplier
      case self.location
      when "all"
        line_item.perimeter
      when "top"
        self.width
      when "bottom"
        self.width
      when "t+b"
        self.width*2
      when "right"
        self.height
      when "left"
        self.height
      when "r+l"
        self.height*2
      when "corners"
        4
      else
        puts "##########################"
        puts "##########################"
        puts "NO ENCONTRO LOCATION"
        puts "##########################"
        puts "##########################"
        1
      end
    end

  end
end