require 'sneakers'
require 'mail'

class Emailer
  include Sneakers::Worker
  from_queue 'emails'

  def work(msg)

    Mail.deliver do
      to msg.recipient
      from 'confirmations@alpineclubofcanada.ca'
      subject "Tell us about your stay!"

      text_part { body 'One line of text content' }
      html_part { body '<h1>Html email content!</h1>' }
    end

    ack!
  end
end
