#
# Run eye client:
#    bundle install
#    ruby eye.rb
#
# Send message:
#    require 'pusher'
#    Pusher.url = "http://ac98d9e6e2c6efc390b1:f066462468e2738749f2@api.pusherapp.com/apps/98709"
#    Pusher.trigger('keep', 'order_processed', {success: true})
#    Pusher.trigger('keep', 'order_processed', {success: false})
#

require 'sphero'
require 'pusher-client'
require 'json'

port = `ls /dev/tty.Sphero*`.strip
sphero = Sphero.new port

Thread.new {
  loop do
    sphero.ping
    sleep 60
  end
}

def blink_red(s)
  red = [255, 0, 0]
  black = [0, 0, 0]
  s.rgb(*red)
  sleep(0.3)
  s.rgb(*black)
  sleep(0.3)
  s.rgb(*red)
  sleep(0.3)
  s.rgb(*black)
end

def order_failed(s)
  s.roll(1, 0)
  blink_red(s)
  s.roll(1, 180)
  blink_red(s)
  blink_red(s)
  s.roll(1, 0)
  blink_red(s)
end

def order_success(s)
  color = [rand(127), rand(127), rand(127)]
  s.rgb(*color.map{|c| c+127})
  s.roll(10, 180)
  sleep 1
  s.rgb(*color.map{|c| c+63})
  s.roll(1, 0)
  sleep(0.9)
  s.rgb(0, 0, 0)
end

socket = PusherClient::Socket.new('ac98d9e6e2c6efc390b1')
socket.subscribe('keep')

socket['keep'].bind('order_processed') do |data|
  puts 'Order processed:'
  puts data
  d = JSON.parse(data)
  d["success"] ? order_success(sphero) : order_failed(sphero)
end

socket.connect
sphero.stop
