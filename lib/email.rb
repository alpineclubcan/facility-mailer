require 'erb'
require 'mail'
require 'hash_dot'

class Email
  FROM = 'confirmations@alpineclubofcanada.ca'.freeze

  Template = Struct.new(:name, :html, :text) do
    def to_template
      self
    end
  end

  attr_reader :options, :data

  def initialize(options: {}, data: {})
    @options = options.to_dot
    @data = data.to_dot
    freeze
  end

  def render
    Mail.new do |m|
      m.from FROM
      m.to options.to
      m.subject options.subject

      m.text_part do |msg| 
        msg.content_type CONTENT_TYPE_TEXT
        msg.body ERB.new(options.template.text, nil, '-').result_with_hash(data) 
      end

      m.html_part do |msg| 
        msg.content_type = CONTENT_TYPE_HTML
        msg.body ERB.new(options.template.html, nil, '-').result_with_hash(data)
      end 
    end
  end

  private

  CONTENT_TYPE_HTML = 'text/html; charset=utf-8'
  CONTENT_TYPE_TEXT = 'text/plain; charset=utf-8'

end
