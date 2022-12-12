
def server
	system("falcon", "serve", "--port", "9292", "--bind", "http://localhost:9292")
end

require 'async'
require 'async/http/internet'
require 'async/http/relative_location'

class RelativeInternet < Async::HTTP::Internet
	def make_client(endpoint)
		# Handle redirects:
		Async::HTTP::RelativeLocation.new(super)
	end
end

def client
	# Console.logger.debug!
	
	urls = [
		"http://localhost:9292/content",
		"http://localhost:9292/redirect-301",
		"http://localhost:9292/redirect-302",
		"http://localhost:9292/redirect-307",
	]
	
	body = <<~MULTIPART.split("\n").join("\r\n") + "\r\n"
	--88d6e799d59ff1968eacd5a7d681cbe8eb128d728f0fefa65e597a4d60a2
	Content-Disposition: form-data; name="hello"
	
	world
	--88d6e799d59ff1968eacd5a7d681cbe8eb128d728f0fefa65e597a4d60a2--
	MULTIPART
	
	Async do
		# internet = Async::HTTP::Internet.new
		internet = RelativeInternet.new
		
		urls.each do |url|
			puts "--- Posting to: #{url}"
			response = internet.post(url, {"content-type" => "multipart/form-data; boundary=88d6e799d59ff1968eacd5a7d681cbe8eb128d728f0fefa65e597a4d60a2"}, body)
			puts response.status
			puts response.headers.inspect
			puts response.read
		end
	end
end
