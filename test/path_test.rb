gem "minitest"
require "minitest/autorun"
require "faraday"
require "./lib/path"
require "Time"

class PathTest < Minitest::Test
  def test_it_outputting_diagnostic
    path = Path.new
    test_request = ["GET /hello HTTP/1.1", 
                    "Host: 127.0.0.1:9292", 
                    "Upgrade-Insecure-Requests: 1", 
                    "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8", 
                    "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_2) AppleWebKit/602.3.12 (KHTML, like Gecko) Version/10.0.2 Safari/602.3.12", 
                    "Accept-Language: en-us", 
                    "Accept-Encoding: gzip, deflate", 
                    "Connection: keep-alive"]
    expected = "<pre>\n    Verb: \"GET\"\n    Path: \"/hello\"\n    Protocol: \"HTTP/1.1\"\n    host: \"127.0.0.1\"\n    Port: \"9292\"\n    Origin: \"127.0.0.1\"\n    accept: \"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\"\n    </pre>"
    
    assert_equal expected, path.handle_root(test_request).lstrip
  end

  def test_it_pesponse_diagnostic_data_if_root
    path = Path.new
    test_request = ["GET /hello HTTP/1.1", 
                    "Host: 127.0.0.1:9292", 
                    "Upgrade-Insecure-Requests: 1", 
                    "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8", 
                    "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_2) AppleWebKit/602.3.12 (KHTML, like Gecko) Version/10.0.2 Safari/602.3.12", 
                    "Accept-Language: en-us", 
                    "Accept-Encoding: gzip, deflate", 
                    "Connection: keep-alive"]
    expected = "<pre>\n    Verb: \"GET\"\n    Path: \"/hello\"\n    Protocol: \"HTTP/1.1\"\n    host: \"127.0.0.1\"\n    Port: \"9292\"\n    Origin: \"127.0.0.1\"\n    accept: \"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\"\n    </pre>"
  
    assert_equal expected, path.response(test_request, "GET / HTTP/1.1").lstrip
    
  end

  def test_it_pesponse_diagnostic_data_if_hello
    path = Path.new
    expected = "<pre>Hello, World.(1)</pre>"
    empty = ""

    assert_equal expected, path.response(empty, "GET /hello HTTP/1.1")
  end

  def test_it_pesponse_diagnostic_data_if_datetime
    path = Path.new
    empty = ""

    assert_equal Time.now.strftime('%a, %e %b %Y %H:%M:%S %z'), path.response(empty, 'GET /datetime HTTP/1.1')
  end

  def test_it_pesponse_diagnostic_data_if_shutdown
    path = Path.new
    empty = ""

    assert_equal "Total Requests: 1", path.response(empty, "GET /shutdown HTTP/1.1")
  end

  def test_return_word_from_dictionary_is_known
    path = Path.new
    empty = ""

    assert_equal "box is a known word", path.response(empty, "GET /word_search?word=box HTTP/1.1")
  end

  def test_return_word_from_dictionary_is_not_known
    path = Path.new
    empty = ""

    assert_equal "sergey is not a known word", path.response(empty, "GET /word_search?word=sergey HTTP/1.1")
  end
end
