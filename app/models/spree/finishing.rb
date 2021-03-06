module Spree
  class Finishing < ActiveRecord::Base

    belongs_to :product
    has_many :finishing_line_items

    enum type_calc: { calc_linear: 0, calc_custom: 1 }

    validates :name, presence: true
    validates :price_multiplier, numericality: true

    default_scope { order(:parent, :position) }
    scope :category, -> { where(:parent => [nil,'', 0]) }
    scope :subcategory, -> (parent) { where(:parent => parent) }

    def init
      self.frequency ||= 1
    end
    
    def has_parent?
      !self.parent.blank? && self.parent > 0 ? true : false
    end

    def is_parent?
      Spree::Finishing.subcategory(self).count > 0 ? true : false
    end

    def need_location?
      !self.loc_required.blank?
    end

    def need_size?
      !self.size_required.blank?
    end

    def padre
      Spree::Finishing.find(self.parent)
    end

  end
end