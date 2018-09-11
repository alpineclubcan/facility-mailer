require 'survey_email'
require 'visit'

describe SurveyEmail do
  FACILITY = Visit::Facility.new("CH", "Canmore Clubhouse")
  VISIT = Visit.new(facility: FACILITY, number_of_nights: 5)

  subject { SurveyEmail.new(recipient: 'lucyloo@skibum.co', visit: VISIT, template: 'template') }

  it "responds to messages" do
    expect(subject).to respond_to(:recipient)
    expect(subject).to respond_to(:visit)
    expect(subject).to respond_to(:template)
  end

  describe ".initialize" do
    it "accepts correct keywords" do
      expect(subject.method(:initialize).parameters).to eq([[:keyreq, :recipient], [:keyreq, :visit], [:keyreq, :template]])
    end
  end
end
