require 'sinatra'
# probably a dumb way to do it, but these are the libraries I'm using for 
# pulling from dnd5eapi.co
require 'json'
require 'uri'
require 'net/http'
require 'openssl'

get '/' do
  "Hello World, it's #{Time.now} at the server!"
end

get '/hello/:name' do |n|
  "Hello #{n}!"
end

def get_spell(spell)
  url = URI("https://www.dnd5eapi.co/api/spells/#{spell}/")

  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true

  request = Net::HTTP::Get.new(url)
  request["Accept"] = 'application/json'

  response = http.request(request)
  response = JSON.parse(response.body)

  puts response
  return response
end

def print_array(x, indentation)
  text = ""
  x.each do |item|
    if item.is_a?(Hash)
      text += print_hash(item, indentation + 40)
    elsif item.is_a?(Array)
      text += print_array(item, indentation + 40)
    else
      text += "<p style=\"text-indent: #{indentation}px\">#{item}</p>"
    end
  end
  return text
end

def print_hash(x, indentation)
  text = ""
  x.map do |key, value|
    if value.is_a?(Hash)
      text += print_hash(value, indentation + 40)
    elsif value.is_a?(Array)
      text += print_array(value, indentation + 40)    
    else
      text += "<p style=\"text-indent: #{indentation}px\">#{key}: #{value}</p>"
    end
  end
  return text
end

get '/spells/:spell' do |spell|
  x = get_spell(spell)
  print_hash(x, 0)
end
