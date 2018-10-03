require 'erb'
require 'mail'

class SurveyEmail
  FROM = 'confirmations@alpineclubofcanada.ca'.freeze

  Template = Struct.new(:html, :text) do
    def to_template
      self
    end
  end

  attr_reader :visit

  def initialize(visit:, template:)
    @visit = visit.to_visit
    @template = template.to_template
    freeze
  end

  def render
    Mail.new do |m|
      m.from FROM
      m.to visit.guest.email.to_s
      m.subject 'Thank you for staying with us!'

      m.text_part do |msg| 
        msg.content_type CONTENT_TYPE_TEXT
        msg.body ERB.new(template.text).result(binding) 
      end

      m.html_part do |msg| 
        msg.content_type = CONTENT_TYPE_HTML
        msg.body ERB.new(template.html).result(binding)
      end 
    end
  end

  private

  CONTENT_TYPE_HTML = 'text/html; charset=utf-8'
  CONTENT_TYPE_TEXT = 'text/plain; charset=utf-8'

  attr_reader :template

end
