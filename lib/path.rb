

class Path
  def initialize
    @hello_counter = 0
    @count = 0
  end

  def response(request_lines, path)
    @count += 1

    # if path == '/favicon.ico'  
    #   client.puts ["http/1.1 404 not-found"]
     
    if path == "GET / HTTP/1.1"
      handle_root(request_lines)
    elsif path == "GET /hello HTTP/1.1"
      handle_hello
    elsif path == "GET /datetime HTTP/1.1"
      handle_datetime
    elsif path == "GET /shutdown HTTP/1.1"
      handle_shutdown
    elsif path   
      dictionary_word(path)
    end
  end

  def handle_root(request_lines)
    verb = request_lines[0].split[0]
    path = request_lines[0].split[1]
    protocol = request_lines[0].split[2]
    host = request_lines[1].split(":")[1].lstrip
    port = request_lines[1].split(":")[2]
    origin = host
    accept = request_lines[3].split(":")[1].lstrip

    header_string = %Q[
    <pre>
    Verb: "#{verb}"
    Path: "#{path}"
    Protocol: "#{protocol}"
    host: "#{host}"
    Port: "#{port}"
    Origin: "#{origin}"
    accept: "#{accept}"
    </pre>]
  end

  def handle_hello
    @hello_counter +=1
    "<pre>" + "Hello, World.(#{@hello_counter})" + "</pre>"
  end

  def handle_datetime
    Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')
  end

  def handle_shutdown
    "Total Requests: #{@count}"
  end

  def dictionary_word(path)
    file = File.read("/usr/share/dict/words")
    word = path.split("=")[1].split(" ")[0]
    
    if file.include?(word)
      "#{word} is a known word"
    else
      "#{word} is not a known word"
    end
  end
end