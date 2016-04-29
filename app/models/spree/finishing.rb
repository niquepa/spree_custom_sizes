module Spree
  class Finishing < ActiveRecord::Base

    belongs_to :product
    #has_many :finishing_options

    validates :name, presence: true
    validates :price_multiplier, numericality: true

    default_scope { order(:parent, :position) }
    scope :category, -> { where(:parent => [nil,'', 0]) }
    scope :subcategory, -> (parent) { where(:parent => parent) }


  end
end