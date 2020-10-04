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

  client.puts "<h1>Counter</h1>"

  number = params["number"].to_i

  client.puts "<p>The current number is #{number}.</p>"
  client.puts "<a href='?number=#{number + 1}'>Add one</a>"
  client.puts "<a href='?number=#{number - 1}'>Minus one</a>"

  puts request_line

  next unless request_line

  client.puts "</body>"
  client.puts "</html>"

  client.close  
end