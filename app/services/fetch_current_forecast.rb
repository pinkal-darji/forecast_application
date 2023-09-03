class FetchCurrentForecast
	attr_accessor :current_user, :params
	def initialize(current_user, params)
		@current_user = current_user
		@params = params
	end

	def call
		#Fetch address
		if params[:address_id].present?
			address = Address.find_by(id: params[:address_id])
		else
			address = current_user.primary_address
		end

		# Send an error message if address does not exist
		if address.present?

			#If data exists in cache, fetch data via cache Or else call an API
			cached = Rails.cache.exist?("forecast_#{address.zip_code}")
			if cached
				forecast = Rails.cache.fetch("forecast_#{address.zip_code}")
				return { data: forecast, success: true, message: "Data", address: address, is_cached: true }
			else
				#I have used weatherstack API to fetch the forecast details
				response = HTTParty.get("http://api.weatherstack.com/forecast?access_key=#{ENV["weather_stack_api_key"]}&query=#{address.full_address}&hourly=1")
				Rails.cache.write("forecast_#{address.zip_code}", JSON.parse(response.body), expires_in: 30.minutes)

				if response.success?
		      forecast = JSON.parse(response.body)
		      return { data: forecast, success: true, message: "Data", address: address, is_cached: false }
		    else
		    	return { success: false, message: 'Failed to fetch weather data'} 
		    end
			end
		else
			return {success: false, message: "Failed to fetch weather data"}
		end
	end
end