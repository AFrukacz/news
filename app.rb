require "sinatra"
require "sinatra/reloader"
require "geocoder"
require "forecast_io"
require "httparty"
def view(template); erb template.to_sym; end
before { puts "Parameters: #{params}" }                                     

# enter your Dark Sky API key here
ForecastIO.api_key = "be89e112d21cf02eb80269c2d6cb7269"

# News API
url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=13454b5bbb1440d3b6a79ad60bf2a395"
news = HTTParty.get(url).parsed_response.to_hash

get "/" do
# show a view that asks for the location
  view "ask"
end

get "/news" do
  # do everything else
results = Geocoder.search(params["q"])
    lat_long = results.first.coordinates # => [lat, long]
    location = results.first.city
    "#{lat_long[0]} #{lat_long[1]}"
    view "news"

    # Define the lat and long
@lat = "#{lat_long [0]}"
@long = "#{lat_long [1]}"


# display current weather
puts "In #{@location}, it is currently #{@current_temperature} and #{@current_conditions}."

# weather forecase
day_hightemp = []
day_condition = []

for day in forecast["daily"]{"data"}
    day_hightemp << "#{day["temperatureHigh"]}"
    day_condition << "#{day["summary"]}"
end