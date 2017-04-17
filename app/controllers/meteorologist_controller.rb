require 'open-uri'

class MeteorologistController < ApplicationController
  def street_to_weather_form
    # Nothing to do here.
    render("meteorologist/street_to_weather_form.html.erb")
  end

  def street_to_weather
    @street_address = params[:user_street_address]

    # ==========================================================================
    # Your code goes below.
    #
    # The street address that the user typed is in the variable @street_address.
    # ==========================================================================

    encoded_address = @street_address.gsub(/[' ']/, '+')
    encoded_url = "http://maps.googleapis.com/maps/api/geocode/json?address="+encoded_address

    parsed_data_address = JSON.parse(open(encoded_url).read)

    latitude = parsed_data_address["results"][0]["geometry"]["location"]["lat"]

    longitude = parsed_data_address["results"][0]["geometry"]["location"]["lng"]

    lat = latitude.to_s
    lng = longitude.to_s

    encoded_url_forecast = "https://api.darksky.net/forecast/e59c8b73230262b7c2375fe787ac773c/"+ lat + "," + lng
    parsed_data_forecast = JSON.parse(open(encoded_url_forecast).read)


    @current_temperature = parsed_data_forecast['currently']['temperature']

    @current_summary = parsed_data_forecast['currently']['summary']

    @summary_of_next_sixty_minutes = parsed_data_forecast['minutely']['summary']

    @summary_of_next_several_hours = parsed_data_forecast['hourly']['summary']

    @summary_of_next_several_days = parsed_data_forecast['daily']['summary']

    render("meteorologist/street_to_weather.html.erb")
  end
end
