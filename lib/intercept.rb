require 'rack'
module Toto
  class Server
    def call_with_intercept(env)
      request = Rack::Request.new env
      path, mime = request.path_info.split('.')

      return call_without_intercept(env) unless path =~/^\/feed_update/
      
      response = Rack::Response.new
      response.body = "Hello!"
      response.status = 200
      response.finish
    end
    alias_method :call_without_intercept, :call
    alias_method :call, :call_with_intercept
  end
end
