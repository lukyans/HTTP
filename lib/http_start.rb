require 'socket'
require './lib/path'

class Start
  attr_reader :request_lines, :raw_response, :server_running

  def initialize
    @raw_response = Path.new
    @request_lines = []
    @server_running = true
  end

  def start_everything
    tcp_server = TCPServer.new(9292)
    
   
    while @server_running 

      client = tcp_server.accept

      puts "Ready for a request"
      @request_lines = []
      
      while line = client.gets and !line.chomp.empty?
        @request_lines << line.chomp #server side
      end

      puts "Got this request:"
      puts @request_lines.inspect

      puts "Sending response."
      path = request_lines[0]
    
      response = raw_response.response(request_lines, path)
      @server_running = false if response.split(":")[0] == "Total Requests"

      @request_lines = []
      
      # response = "<pre>" + "Hello, World.(#{counter})" + "</pre>"
      output = "<html><head></head><body>#{response}</body></html>"
      headers = ["http/1.1 200 ok",
                "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
                "server: ruby",
                "content-type: text/html; charset=iso-8859-1",
                "content-length: #{output.length}\r\n\r\n"].join("\r\n")
      client.puts headers
      client.puts output
      
      puts ["Wrote this response:", headers, output].join("\n")
      client.close
      puts "\nResponse complete, exiting."

    end
    #client.close
  end
end

server = Start.new
server.start_everything
