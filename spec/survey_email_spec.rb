require 'survey_email'
require 'visit'
require 'guest'

describe SurveyEmail do
  FACILITY = Visit::Facility.new("CH", "Canmore Clubhouse")
  VISIT = Visit.new(facility: FACILITY, guest: Guest.new(email: Guest::EmailAddress.new('mountain@acc.net'), name: Guest::EmptyName.new), number_of_nights: 5)
  TEMPLATE = SurveyEmail::Template.new('<h1>HTML version</h1>', 'This is text version of email.')

  subject { SurveyEmail.new(visit: VISIT, template: TEMPLATE) }

  it "responds to messages" do
    expect(subject).to respond_to(:render)
  end

  describe "#initialize" do
    it "accepts correct keywords" do
      expect(subject.method(:initialize).parameters).to eq([[:keyreq, :visit], [:keyreq, :template]])
    end

    it "freezes the object" do
      expect(subject).to be_frozen
    end
  end
end
