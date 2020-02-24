require "sinatra"
require "sinatra/reloader"
require "geocoder"
require "forecast_io"
require "httparty"
def view(template); erb template.to_sym; end
before { puts "Parameters: #{params}" }                                     

# enter your Dark Sky API key here
ForecastIO.api_key = "be89e112d21cf02eb80269c2d6cb7269"


get "/" do
# show a view that asks for the location
  view "ask"
end


# NEWS FILE CODE BEGINS HERE
get "/news" do
  # do everything else
    results = Geocoder.search(params["q"])
    lat_long = results.first.coordinates # => [lat, long]
    lat = lat_long[0]
    long = lat_long[1]
    @location = results.first.city.capitalize


# pull forecast
    @forecast = ForecastIO.forecast(lat,long).to_hash
    @current_temp = @forecast["currently"]["temperature"]
    @current_cond = @forecast["currently"]["summary"]
    @daily_temp = []
    @daily_cond = []
    for @day_forecast in @forecast["daily"]["data"] do
        @daily_temp << @day_forecast["temperatureHigh"]
        @daily_cond << @day_forecast["summary"]
    end

# pull news
    url = "https://newsapi.org/v2/top-headlines?country=us&language=en&apiKey=13454b5bbb1440d3b6a79ad60bf2a395"
    @news = HTTParty.get(url).parsed_response.to_hash
    @news_title = []
    @story_url = []
    for daily_news in @news["articles"] do
        @news_title << daily_news["title"]
        @story_url << daily_news["url"]
    end

    view "news"
end
