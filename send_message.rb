require 'pusher'

Pusher.url = "http://ac98d9e6e2c6efc390b1:f066462468e2738749f2@api.pusherapp.com/apps/98709"

Pusher.trigger('keep', 'order_processed', {success: true, status: 'success'})
