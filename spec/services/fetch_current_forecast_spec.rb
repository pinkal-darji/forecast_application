require 'rails_helper'

describe FetchCurrentForecast, type: :service do
  let(:user) { create(:user) } # Assuming you have a User factory
  let(:address) { create(:address, user: user) } # Assuming you have an Address factory

  describe '#call' do
    context 'when the address exists' do
      before do
        allow(Rails.cache).to receive(:exist?).and_return(false)
        allow(HTTParty).to receive(:get).and_return(
          double(success?: true, body: '{"temperature": 25, "description": "Sunny"}')
        )
      end

      it 'fetches weather data from the API and caches it' do
        fetcher = FetchCurrentForecast.new(user, params: { address_id: address.id })
        result = fetcher.call

        expect(result[:success]).to be_truthy
        expect(result[:data]).to eq({ "temperature" => 25, "description" => "Sunny" })
        expect(result[:is_cached]).to be_falsey
        expect(result[:address]).to eq(address)

        # Verify that the cache was written
        expect(Rails.cache).to have_received(:write).with("forecast_#{address.zip_code}", anything, expires_in: 30.minutes)
      end

      it 'fetches weather data from the cache if it exists' do
        allow(Rails.cache).to receive(:exist?).and_return(true)
        allow(Rails.cache).to receive(:fetch).and_return({ "temperature" => 25, "description" => "Sunny" })

        fetcher = FetchCurrentForecast.new(user, params: { address_id: address.id })
        result = fetcher.call

        expect(result[:success]).to be_truthy
        expect(result[:data]).to eq({ "temperature" => 25, "description" => "Sunny" })
        expect(result[:is_cached]).to be_truthy
        expect(result[:address]).to eq(address)

        # Ensure that HTTParty.get was not called
        expect(HTTParty).not_to have_received(:get)
      end

      it 'handles a failed API request' do
        allow(HTTParty).to receive(:get).and_return(double(success?: false))
        fetcher = FetchCurrentForecast.new(user, params: { address_id: address.id })
        result = fetcher.call

        expect(result[:success]).to be_falsey
        expect(result[:message]).to eq('Failed to fetch weather data')
      end
    end

    context 'when the address does not exist' do
      it 'returns an error message' do
        fetcher = FetchCurrentForecast.new(user, params: { address_id: 999 }) # Assuming an invalid address_id
        result = fetcher.call

        expect(result[:success]).to be_falsey
        expect(result[:message]).to eq('Failed to fetch weather data')
      end
    end
  end
end
