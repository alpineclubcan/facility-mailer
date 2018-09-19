require 'sneakers'
require 'mail'

class Emailer
  include Sneakers::Worker
  from_queue 'emails'

  def work(email)
    message = email.render
    message.deliver!

    ack!
  end
end
