# require 'bundler/setup'
# Bundler.require(:default)

require 'artoo'

s = `ls /dev/tty.Sphero*`.strip
connection :sphero, adaptor: :sphero, port: s
device :sphero, driver: :sphero

# http://localhost:4321/#/robots
api host: '127.0.0.1', port: '4321'

work do
  sphero.set_color(:green)
  sleep(2)
  sphero.set_color(:blue)
  sleep(2)
  sphero.set_color(:red)
end
