require 'survey_email'
require 'visit'

describe SurveyEmail do
  TEMPLATE = 'template'.freeze
  RECIPIENT = 'lucyloo@skibum.co'.freeze
  FACILITY = Visit::Facility.new("CH", "Canmore Clubhouse")
  VISIT = Visit.new(facility: FACILITY, number_of_nights: 5)

  subject { SurveyEmail.new(recipient: RECIPIENT, visit: VISIT, template: TEMPLATE) }

  it "responds to messages" do
    expect(subject).to respond_to(:recipient)
    expect(subject).to respond_to(:visit)
    expect(subject).to respond_to(:template)
    expect(subject).to respond_to(:mail)
  end

  describe "#initialize" do
    it "accepts correct keywords" do
      expect(subject.method(:initialize).parameters).to eq([[:keyreq, :recipient], [:keyreq, :visit], [:keyreq, :template]])
    end

    it "creates access to attributes through messages" do
      expect(subject.recipient).to eq(RECIPIENT)
      expect(subject.visit).to eq(VISIT)
      expect(subject.template).to eq(TEMPLATE)
    end

    it "freezes the object" do
      expect(subject).to be_frozen
    end
  end

  describe "#mail" do

  end
end
