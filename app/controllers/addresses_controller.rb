class AddressesController < ApplicationController
	before_action :authenticate_user! # Added this line to require authentication

	# Fetch all addresses associated to current user
	def index
		@addresses = current_user.addresses
	end

# Add new address for current user
	def new
		@address = current_user.addresses.new
	end

	def create
		@address = current_user.addresses.new(address_params)
    if @address.save
      redirect_to addresses_path, notice: 'Address was successfully created.'
    else
      render :new
    end
	end

	private

  def address_params
    params.require(:address).permit(:address_line, :city, :state, :country, :zip_code)
  end
end

