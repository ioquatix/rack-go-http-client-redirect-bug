
class Bug
	def call(env)
		case env['PATH_INFO']
		when /\/redirect-(\d+)/
			return [$1.to_i, {'location' => '/content'}, []]
		else
			request = Rack::Request.new(env)
			return [200, {'content-type' => 'text/plain'}, [request.params.inspect]]
		end
	end
end

run Bug.new
