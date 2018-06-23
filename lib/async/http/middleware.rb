# Copyright, 2017, by Samuel G. D. Williams. <http://www.codeotaku.com>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

module Async
	module HTTP
		GET = 'GET'.freeze
		HEAD = 'HEAD'.freeze
		POST = 'POST'.freeze
		PUT = 'PUT'.freeze
		PATCH = 'PATCH'.freeze
		DELETE = 'DELETE'.freeze
		
		VERBS = [GET, HEAD, POST, PUT, PATCH, DELETE].freeze
		
		module Verbs
			VERBS.each do |verb|
				define_method(verb.downcase) do |location, headers = {}, body = []|
					self.call(Request[verb, location.to_str, headers, body])
				end
			end
		end
		
		class Middleware
			def initialize(app)
				@app = app
			end
			
			def close
				@app.close
			end
			
			include Verbs
			
			def call(*args)
				@app.call(*args)
			end
			
			module Okay
				def self.close
				end
				
				def self.call(request, *)
					Response[200, {}, []]
				end
			end
			
			module HelloWorld
				def self.close
				end
				
				def self.call(request, *)
					Response[200, {'content-type' => 'text/plain'}, ["Hello World!"]]
				end
			end
		end
	end
end
