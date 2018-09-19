require 'erb'

class SurveyEmail
  Template = Struct.new(:html, :text)

  attr_reader :visit

  def initialize(visit:)
    @visit = visit
    freeze
  end

  def render(template:)
  end
end
