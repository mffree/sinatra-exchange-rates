require "sinatra"
require "sinatra/reloader"
require "dotenv/load"
require "http"
require "json"

api_key = ENV.fetch("EXCHANGE_RATE_KEY")

get("/") do
  # Getting all available currencies
  raw_response = HTTP.get("https://api.exchangerate.host/list?access_key=#{api_key}")
  parsed_response = JSON.parse(raw_response)
  avail_currencies = parsed_response["currencies"]
  # pp avail_currencies

  @abbreviated_currencies = avail_currencies.keys
  # pp @abbreviated_currencies
  erb(:homepage)
end

get("/:first_currency_route") do
  # Getting all available currencies
  raw_response = HTTP.get("https://api.exchangerate.host/list?access_key=#{api_key}")
  parsed_response = JSON.parse(raw_response)
  avail_currencies = parsed_response["currencies"]
  # pp avail_currencies

@abbreviated_currencies = avail_currencies.keys
  @first_currency = params["first_currency_route"]
  erb(:second_currency_page)
end


get("/:first_currency_route/:second_currency_route") do
  # Getting the exchange rate for each currency
  @first_currency = params["first_currency_route"]
  @second_currency = params["second_currency_route"]
  # Creating an endpoint URL with the right currencies in the query string
  endpoint2 = "https://api.exchangerate.host/convert?from=#{@first_currency}&to=#{@second_currency}&amount=1&access_key=#{api_key}"
  raw_response_2 = HTTP.get(endpoint2)
  parsed_response_2 = JSON.parse(raw_response_2)
  # pp parsed_response_2
  @rate = parsed_response_2["result"]
    
  erb(:results)
end
