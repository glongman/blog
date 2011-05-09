require 'thin'
module Thin::Backends
  class Base
    def start
      @stopping = false
      starter = proc do
        connect
        @running = true
        Foursquare.run  # hack: here I know the EM reactor is running!
      end

      if EventMachine.reactor_running?
        starter.call
      else
        EventMachine.run(&starter)
      end
    end
  end
end

