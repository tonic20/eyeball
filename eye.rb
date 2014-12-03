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

Thread.new do
  loop do
    sphero.ping
    sleep 60
  end
end

def blink_red(s)
  Thread.new do
    red = [255, 0, 0]
    black = [0, 0, 0]
    10.times do
      s.rgb(*red)
      sleep(0.2)
      s.rgb(*black)
      sleep(0.2)
    end
  end
end

def order_failed(s)
  blink_red(s)
  s.roll(1, 180)
  sleep 1.2
  s.roll(1, 0)
end

def blink_green(s)
  Thread.new do
    color = [rand(127), rand(127)+127, rand(127)+127]
    black = [0, 0, 0]
    3.times do
      s.rgb(*color)
      sleep(0.3)
      s.rgb(*black)
      sleep(0.2)
      s.rgb(*color)
      sleep(0.5)
      s.rgb(*black)
      sleep(0.2)
    end
  end
end

def order_success(s)
  blink_green(s)
  0.step(360*3, 20) do |i|
    s.roll(0, i % 360)
    sleep 0.05
  end
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
