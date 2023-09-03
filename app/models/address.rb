class Address < ApplicationRecord
  belongs_to :user	
  def full_address
    [address_line, city, state, country, zip_code].reject(&:blank?).join(", ")
  end
  
end
