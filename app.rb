require "bundler/setup"
# require "../ALLKEYS"
require 'pry'

Bundler.require :default
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

Info.save_lat(0)
Info.save_lng(0)

get("/") do
  erb(:index)
end

get('/ruby_data') do
  # data to be passed to javascript
  if (Info.get_lat != 0)
    [{lat: Info.get_lat,lng: Info.get_lng}].to_json
  else
    [{lat: 44.06, lng: -121.32}].to_json
  end
end

post('/get_city') do
  city_name = params.fetch('city_name')
  found_sightings = []
  result = Ufo.find_by_sql("SELECT * FROM ufos WHERE city = '#{city_name}';")
  found_sightings.push(result)
  @results_total = result.count
  # returns a single record for city_name
  single_city_record = Ufo.find_by(city: city_name)
  Info.save_lat(single_city_record['latitude'])
  Info.save_lng(single_city_record['longitude'])
  erb(:index)
end


# AJAX EXAMPLE

# get '/' do
#   erb :index
# end

# get('/play')do
#   if request.xhr?
#     %q{<h1 class="blue">Hello! <a href="/">back</a></h1>}
#   else
#     "<h1>Not an Ajax request!</h1>"
#   end
# end


# JSON NOTES

# File.open("./public/js/data.json","w") do |file|
#   file.write(coords)
# end

# var javascript_side_json = <%= @rails_side_json.html_safe %>;
# or
# var javascript_side_json = <%=raw @rails_side_json %>;
#
# JSON.generate({:this => "is cool"})

# File.open("./temp.js","w") do |file|
#   file.write(coords.to_json)
# end
