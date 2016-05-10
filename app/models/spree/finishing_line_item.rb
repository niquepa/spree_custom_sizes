module Spree
  class FinishingLineItem < ActiveRecord::Base

    belongs_to :line_item
    belongs_to :finishing

    validates :price_multiplier, numericality: true
    validates :price_modifier, numericality: true
    validates :quantity, numericality: true

    before_validation :copy_price_multiplier
    before_validation :copy_frequency
    before_validation :copy_width_height
    before_validation :calc_quantity
    before_validation :calc_price_modifier

    def copy_price_multiplier
      self.price_multiplier = finishing.price_multiplier
    end

    def copy_frequency
      self.frequency = self.finishing.frequency || 2
    end

    def copy_width_height
      self.width = line_item.unit == "ft" ? line_item.width : (line_item.width/12.0).ceil
      self.height = line_item.unit == "ft" ? line_item.height : (line_item.height/12.0).ceil
    end

    def calc_quantity
      self.quantity = location_units * line_item.quantity
    end

    def calc_price_modifier
      self.price_modifier = self.quantity * self.price_multiplier
    end

    def location_units
      case self.location
      when "all"
        self.finishing.calc_linear? ? all_location_linear : all_location
      when "top", "bottom"
        self.finishing.calc_linear? ? top_location_linear : top_location
      when "t+b"
        self.finishing.calc_linear? ? top_bottom_location_linear : top_bottom_location
      when "left", "right"
        self.finishing.calc_linear? ? right_location_linear : right_location
      when "r+l"
        self.finishing.calc_linear? ? right_left_location_linear : right_left_location
      when "corners"
        4
      else
        4
      end
    end

    def top_location
      top_location = (self.width/frequency.to_f).ceil
      top_location = 2 unless top_location > 2
      top_location
    end

    def top_location_linear
      self.line_item.width
    end

    def right_location
      right_location = (self.height/frequency.to_f).ceil
      right_location = 2 unless right_location > 2
      right_location
    end

    def right_location_linear
      self.line_item.height
    end

    def top_bottom_location
      top_location * 2
    end

    def top_bottom_location_linear
      top_location_linear * 2
    end

    def right_left_location
      right_location * 2
    end

    def right_left_location_linear
      right_location_linear * 2
    end

    def all_location
      all_location = (top_bottom_location)+(right_left_location)-4
      all_location = 4 unless all_location > 4
      all_location
    end

    def all_location_linear
      self.line_item.perimeter
    end

  end
end