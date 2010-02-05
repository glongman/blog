require 'toto'

# Rack config
use Rack::Static, :urls => ['/css', '/js', '/images', '/favicon.ico'], :root => 'public'
use Rack::ShowExceptions
use Rack::CommonLogger

# Run application
toto = Toto::Server.new do
  #
  # Add your settings here
  # set [:setting], [value]
  #
  set :author,		'Geoff Longman'
  set :title, 		'Ramblings by MetaGeoff'
  set :url,				'http://metageoff.com'
	set :root,			'index'
  set :markdown,	:smart
  set :disqus, 		'ramblingsbymetageoff'
	set :summary,   :max => 150, :delim => /~\n/ 
	set :ext,				'txt'
  set :date,			lambda {|now| now.strftime("%B #{now.day.ordinal} %Y") }
end

run toto

