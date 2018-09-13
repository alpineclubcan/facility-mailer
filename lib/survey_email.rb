class SurveyEmail
  attr_reader :recipient, :visit, :template

  def initialize(recipient:, visit:, template:)
    @recipient = recipient
    @visit = visit
    @template = template
    freeze
  end

  def mail

  end
end
