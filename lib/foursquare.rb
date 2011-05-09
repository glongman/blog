require 'eventmachine'
require 'json'
require 'lib/globe'
module Foursquare
  def self.run
    print :running_4sq
    $result = "running"
    conn = EventMachine::Protocols::HttpClient2.connect(
      :host => "feeds.foursquare.com",
      :port => 443,
      :ssl => true
    )
    req = conn.get  "/history/#{ENV['FEED_KEY']}.rss?count=1000"
    req.callback do  |response|  
      if req.status != 200
        $foursquare_json = :"http_status_#{req.status}"
        puts " #{$foursquare_json}"
        reschedule_pull
        return
      end

      xml = response.content
      data = Globe.process(xml)
      if data.is_a? Symbol
        $foursquare_json = data
        puts " #{$foursquare_json}"
      else
        $foursquare_json = data.flatten.to_json
        puts " ok"
      end
      reschedule_pull
    end
  end

  def self.reschedule_pull
    EventMachine.add_timer(5 * 60) { Foursquare.run }
  end
end

