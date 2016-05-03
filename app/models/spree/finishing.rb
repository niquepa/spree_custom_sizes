module Spree
  class Finishing < ActiveRecord::Base

    belongs_to :product
    has_many :finishing_line_items

    validates :name, presence: true
    validates :price_multiplier, numericality: true

    default_scope { order(:parent, :position) }
    scope :category, -> { where(:parent => [nil,'', 0]) }
    scope :subcategory, -> (parent) { where(:parent => parent) }

    def has_parent?
      !self.parent.blank? ? true : false
    end

  end
end