require 'hpricot'
module Globe
  MAX_MAG = 30
  def self.process(xml)
    data = bucketize(xml) + MY_OLD_LIFE
    max = data.inject(0) {|max, checkin| checkin.mag > max ? checkin.mag : max }
    mag_normalizer = 0.2/max
    data.collect {|d| d.to_a(mag_normalizer)}
  rescue => ex
    puts "#{ex}\n#{ex.backtrace.join("\n")}"
    :error
  end
  
  def self.bucketize(xml)
    buckets = []
    doc = Hpricot.XML(xml)
    (doc/'item').each do |item|
      location = (item/'georss:point').inner_html
      next unless location =~/(\d*.\d\d\d)\d* (-\d*.\d\d\d)\d*/
      lat = $1.to_f; long = $2.to_f 
      checkin = Globe::Checkin.new(lat, long)
      if buckets.empty?
        checkin.mag = MAX_MAG # most recent pokes up into the sky
        checkin.color = 7 # most recent is red
        buckets << checkin
      else
        existing = buckets.detect {|c| checkin.coord_eq? c }
        (existing.mag = [existing.mag + 1, MAX_MAG].min ) and next if existing
        buckets << checkin
      end
    end
    buckets + MY_OLD_LIFE
  end
  
  class Checkin
    attr_reader :lat, :long
    attr_accessor :mag, :color
    def initialize(lat, long)
      @lat = normalize(lat)
      @long = normalize(long)
      @mag = 1
      @color = 10
    end

    def coord_eq?(checkin)
      checkin.lat == lat && checkin.long == long
    end

    def to_a(mag_normalizer=1)
      [lat, long, format("%0.1f", mag * mag_normalizer).to_f, color]
    end

    def to_s
      to_a.inspect
    end

    # put lat or long value into one of 4 buckets
    # calcuated by the decimal part
    #
    # brutish and ugly
    def normalize(value)
      ltz = value < 0
      whole_part = value.to_i
      rational_part = ((value * 1000).to_i - (whole_part * 1000)).abs

      rational_part = if rational_part > 750
                        750
                      elsif rational_part > 500
                        500
                      elsif rational_part > 250
                        250
                      else
                        0
                      end
      rational_part = rational_part * -1 if ltz
      whole_part + (rational_part / 1000.0)
    end
  end
  
  # I was alive and going places for 40+ years before 4sq came along
  # displayed in blue
  MY_OLD_LIFE = [
    [53.5,-113.5],
    [52.75, -110.75],
    [49.00, -123.00],
    [49.00, -122.25],
    [49.25, -121.25],
    [49.00, -121.750],
    [43.5, -79.25],
    [44.75, -79.75],
    [44.25, -79.75],
    [46.0, -64.75],
    [38.75, -77.00],
    [42.21, -71.00],
    [37.5, -122.25],
    [37.75, -122.25],
    [52.0, -106.25],
    [52.75, -105.0],
    [28.5, -81.25],
    [30.0, -81.5],
    [41.75, -87.25],
    [44.5, -63.5],
    [45.5, -77.0],
    [45.0, -73.5],
    [48.5, -123.25],
    [47.5, -122.25]
  ].map do |entry|
    e = Globe::Checkin.new(entry.first, entry.last)
    e.color = 3
    e
  end
end
