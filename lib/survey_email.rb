require 'erb'
require 'mail'

class SurveyEmail
  FROM = 'confirmations@alpineclubofcanada.ca'.freeze

  Template = Struct.new(:html, :text) do
    def to_template
      self
    end
  end

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

      m.text_part { |msg| msg.body ERB.new(template.text).result(binding) }
      m.html_part { |msg| msg.body ERB.new(template.html).result(binding) }
    end
  end

  private

  attr_reader :visit, :template

end
