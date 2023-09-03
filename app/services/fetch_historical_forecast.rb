class FetchHistoricalForecast
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
				return { data: forecast, success: true, message: "Data", address: address }
			else
				#I have used weatherstack API to fetch the forecast details
				response = generate_api_call
				Rails.cache.write("forecast_#{address.zip_code}", JSON.parse(response.body), expires_in: 30.minutes)

				if response.success?
		      forecast = JSON.parse(response.body)
		      return { data: forecast, success: true, message: "Data", address: address }
		    else
		    	return { success: false, message: 'Failed to fetch weather data'} 
		    end
			end
		else
			return {success: false, message: "Failed to fetch weather data"}
		end
	end

	def generate_api_call
		if params[:date_range].present? && params[:date_range][:start_date].to_date == params[:date_range][:end_date].to_date
			#  To fetch data for particular day hourwise
			response = HTTParty.get("http://api.weatherstack.com/forecast?access_key=#{ENV["weather_stack_api_key"]}&query=#{address.full_address}&hourly=1&forecast_days=1")
		else
			# To fetch data for multiple days, Response will differ in both cases.
			response = HTTParty.get("http://api.weatherstack.com/historical?access_key=#{ENV["weather_stack_api_key"]}&query=#{address.full_address}&historical_date_start=#{params[:date_range][:start_date]}&historical_date_end=#{params[:date_range][:end_date]}")
		end
	end
end