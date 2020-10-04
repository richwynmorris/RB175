require "socket"

def parse_request(request)
  elements = request.split(/[ ?&]/)

  method = ''
  path = ''
  params = {}
  http_version = ''

  elements.each_with_index do |element, index|
      if index == 0
        method = element
      elsif index == 1
        path = element
      elsif index != elements.length - 1
        params[element.split('=')[0]] = element.split('=')[1]
      else
        http_version = element
      end
  end

  [method, path, params, http_version]
end


server = TCPServer.new("localhost", 3003)

loop do
  client = server.accept

  request_line = client.gets # => GET /?rolls=2&sides=6 HTTP/1.1
  next if !request_line || request_line =~ /favicon/

  method, path, params, http_version = parse_request(request_line)

  client.puts "HTTP/1.0 200 OK" # status code
  client.puts "Content-Type: text/html"
  client.puts 
  client.puts "<html>"
  client.puts "<body>"
  client.puts "<pre>"
  client.puts method
  client.puts path
  client.puts params
  client.puts "</pre>"

  puts request_line

  client.puts "<h1>Rolls!</h1>"
  rolls = params['rolls'].to_i
  sides = params['sides'].to_i

  rolls.times do 
    roll = rand(sides) + 1
    client.puts "<p>", roll, "</p>"
  end

  client.puts "</body>"
  client.puts "</html>"

  client.close  
end