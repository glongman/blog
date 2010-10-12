
require 'toto'

# Rack config
use Rack::Static, :urls => ['/css', '/js', '/images', '/favicon.ico'], :root => 'public'
use Rack::CommonLogger
use Rack::ContentType, "text/html"

if ENV['RACK_ENV'] == 'development'
  use Rack::ShowExceptions
end

#
# Create and configure a toto instance
#
toto = Toto::Server.new do
  #
  # Add your settings here
  # set [:setting], [value]
  #
  set :author,		'metageoff'
  set :title, 		'Ramblings by MetaGeoff'
  set :url,				'http://metageoff.com'
	set :root,			'index'
  set :markdown,	:smart
  set :disqus, 		'ramblingsbymetageoff'
	set :summary,   :max => 100, :delim => /~\n/ 
	set :ext,				'txt'
  set :date,			lambda {|now| now.strftime("%B #{now.day.ordinal} %Y") }
  set :cache,     28800
end

run toto


