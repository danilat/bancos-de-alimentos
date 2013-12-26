require 'sinatra'
require 'rest_client'
require 'json'
require File.join(File.dirname(__FILE__), '', 'config') #to externalize API_KEY configuration

get '/' do
  sql = "SELECT * from bancosdealimentos WHERE the_geom is not NULL"
  url = "http://danilat.cartodb.com/api/v2/sql?q=#{sql}&api_key=#{API_KEY}"
  response = RestClient.get  URI.escape(url)  
  data = JSON.parse(response)
  puts response
  erb :index, :locals => {:data => data}
end

post 'create' do
  sql = "INSERT INTO bancosdealimentos (address, contact, type) VALUES ('#{address}', '#{contact}', 'autogestionado')"
  url = "http://danilat.cartodb.com/api/v2/sql?q=#{sql}&api_key=#{API_KEY}"
  response = RestClient.post url
  puts response.code
  redirect to('/?ok=ok')
end

