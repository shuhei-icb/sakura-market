module Taxable
  extend ActiveSupport::Concern

  TAX_RATE = '1.10'.freeze

  def self.including_tax(price)
    (BigDecimal(price.to_s) * BigDecimal(TAX_RATE)).floor
  end
end
