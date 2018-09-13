require 'survey_email'
require 'visit'

describe SurveyEmail do
  GUEST = 'lucyloo@skibum.co'.freeze
  FACILITY = Visit::Facility.new("CH", "Canmore Clubhouse")
  VISIT = Visit.new(facility: FACILITY, number_of_nights: 5)

  subject { SurveyEmail.new(guest: GUEST, visit: VISIT) }

  it "responds to messages" do
    expect(subject).to respond_to(:guest)
    expect(subject).to respond_to(:visit)
    expect(subject).to respond_to(:render).with_keywords(:template)
  end

  describe "#initialize" do
    it "accepts correct keywords" do
      expect(subject.method(:initialize).parameters).to eq([[:keyreq, :guest], [:keyreq, :visit]])
    end

    it "creates access to attributes through messages" do
      expect(subject.guest).to eq(GUEST)
      expect(subject.visit).to eq(VISIT)
    end

    it "freezes the object" do
      expect(subject).to be_frozen
    end
  end
end
