module ForeCastsHelper
	def fetch_uv_index_value(uv_index)
		case uv_index
		when 0..2
			value = "Low"
		when 3..5
			value = "Moderate"
		when 6..7
			return "High"
		when 8..10
			value = "Very high"
		else
			value = "Extreme"
		end
	end
end
