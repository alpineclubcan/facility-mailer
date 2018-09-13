require 'erb'

class SurveyEmail
  Template = Struct.new(:html, :text)

  attr_reader :guest, :visit

  def initialize(guest:, visit:)
    @guest = guest
    @visit = visit
    freeze
  end

  def render(template:)
  end
end
