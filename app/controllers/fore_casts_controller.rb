class ForeCastsController < ApplicationController

	#Action to fetch the forecast data via address
	def index
		if params[:date_range].present?
			response = FetchHistoricalForecast.new(current_user, params).call
		else
			response = FetchCurrentForecast.new(current_user, params).call
		end

		if response[:success]
			@forecast = response[:data]
			@address = response[:address]
			@is_cached = response[:is_cached]
			@is_historical = params[:date_range].present?
		else
			flash[:error] = response["message"]
		end
	end
end
