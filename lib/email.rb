require 'erb'
require 'mail'
require 'hash_dot'

class Email
  FROM = 'confirmations@alpineclubofcanada.ca'.freeze

  Template = Struct.new(name:, :html, :text) do
    def to_template
      self
    end
  end

  attr_reader :options, :data

  def initialize(options: {}.to_dot, data: {}.to_dot)
    @options = options
    @data = data
    freeze
  end

  def render
    Mail.new do |m|
      m.from FROM
      m.to options.to
      m.subject options.subject

      m.text_part do |msg| 
        msg.content_type CONTENT_TYPE_TEXT
        msg.body ERB.new(options.template.text).result_with_hash(data) 
      end

      m.html_part do |msg| 
        msg.content_type = CONTENT_TYPE_HTML
        msg.body ERB.new(options.template.html).result_with_hash(data)
      end 
    end
  end

  private

  CONTENT_TYPE_HTML = 'text/html; charset=utf-8'
  CONTENT_TYPE_TEXT = 'text/plain; charset=utf-8'

end
