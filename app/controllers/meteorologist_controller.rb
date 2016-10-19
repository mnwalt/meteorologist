require 'open-uri'

class MeteorologistController < ApplicationController
  def street_to_weather_form
    # Nothing to do here.
    render("meteorologist/street_to_weather_form.html.erb")
  end

  def street_to_weather
    @street_address = params[:user_street_address]
    @street_address_without_spaces = URI.encode(@street_address)

    # ==========================================================================
    # Your code goes below.
    # The street address the user input is in the variable @street_address.
    # A URL-safe version of the street address, with spaces and other illegal
    #   characters removed, is in the variable @street_address_without_spaces.
    # ==========================================================================

    puts "Here's the outlook for " + @street_address

    parsed_data_gmap = JSON.parse(open("http://maps.googleapis.com/maps/api/geocode/json?address=" + @street_address_without_spaces).read)

    @lat = parsed_data_gmap["results"][0]["geometry"]["location"]["lat"].to_s

    @lng = parsed_data_gmap["results"][0]["geometry"]["location"]["lng"].to_s

    parsed_data_ds = JSON.parse(open("https://api.darksky.net/forecast/4c12242f55f6b7c306e6011d366e3dfe/" + @lat +"," + @lng).read)

    @current_temperature = parsed_data_ds["currently"]["temperature"]

    @current_summary = parsed_data_ds["currently"]["summary"]

    @summary_of_next_sixty_minutes = parsed_data_ds["minutely"]["summary"]

    @summary_of_next_several_hours =  parsed_data_ds["hourly"]["summary"]

    @summary_of_next_several_days =   parsed_data_ds["daily"]["summary"]

    render("meteorologist/street_to_weather.html.erb")
  end
end
