gem "minitest"
require "minitest/autorun"
require "faraday"

class HttpStartTest < Minitest::Test
  def test_increments_counter_when_requested 
    response = Faraday.get 'http://127.0.0.1:9292/hello'#client side

    expected = "<html><head></head><body><pre>Hello, World.(1)</pre></body></html>"
    assert_equal expected, response.body

    response = Faraday.get 'http://127.0.0.1:9292/hello'
    expected = "<html><head></head><body><pre>Hello, World.(2)</pre></body></html>"
    assert_equal expected, response.body
  end
end
