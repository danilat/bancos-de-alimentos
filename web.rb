require 'sinatra'
require 'rest_client'
require 'json'
require './config' if File.exists?('config.rb') #to externalize API_KEY configuration

get '/' do
  sql = "SELECT * from bancosdealimentos WHERE the_geom is not NULL"
  url = "https://danilat.cartodb.com/api/v2/sql?q=#{sql}&api_key=#{ENV['API_KEY']}"
  response = RestClient.get URI.escape(url)  
  data = JSON.parse(response)
  erb :index, :locals => {:data => data}
end

post '/create' do
  address = "#{params[:address]}. #{params[:place]}"
  contact = params[:contact]
  if params[:address] && params[:place] && params[:address] != "" && params[:place] != ""
    sql = "INSERT INTO bancosdealimentos (full_address, contact, type) VALUES ('#{address}', '#{contact}', 'Autogestionado')"
    url = "https://danilat.cartodb.com/api/v2/sql?api_key=#{ENV['API_KEY']}"
    response = RestClient.post URI.escape(url), :q => sql
    redirect to('/?ok=ok')
  else
    redirect to('/?ok=no')
  end
end

