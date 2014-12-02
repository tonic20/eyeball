#
# Run eye client:
#    bundle install
#    ruby eye.rb
#
# Send message:
#    require 'pusher'
#    Pusher.url = "http://ac98d9e6e2c6efc390b1:f066462468e2738749f2@api.pusherapp.com/apps/98709"
#    Pusher.trigger('keep', 'order_processed', {success: true, status: 'success'})
#

require 'sphero'
require 'pusher-client'

port = `ls /dev/tty.Sphero*`.strip
sphero = Sphero.new port
sphero.ping

socket = PusherClient::Socket.new('ac98d9e6e2c6efc390b1')

socket.subscribe('keep')

socket['keep'].bind('order_processed') do |data|
  puts 'order_processed'
  sphero.rgb(rand(255), rand(255), rand(255))
end

socket.connect

sphero.stop
