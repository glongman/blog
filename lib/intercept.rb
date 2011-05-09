require 'rack'
module Toto
  class Server
    def call_with_intercept(env)
      request = Rack::Request.new env
      return call_without_intercept(env) unless request.path_info =~/^\/live\.json/

      return [
        302, 
        {'Location' => '/static/Geoff.json'}, 
        ["#{$foursquare_json} : Live  json in not available yet = using static"]
      ] if $foursquare_json.is_a? Symbol

      [
        200,
        {
          'Content-Type' => 'application/json',
          'Content-Length' => $foursquare_json.length.to_s
        },
        [$foursquare_json]
      ]
    end
    alias_method :call_without_intercept, :call
    alias_method :call, :call_with_intercept
  end
end

