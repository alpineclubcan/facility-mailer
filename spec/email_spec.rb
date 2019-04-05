require 'email'
require 'itinerary'
require 'guest'

describe Email do
  facility = Itinerary::Facility.new("CH", "Canmore Clubhouse")
  itinerary = Itinerary.new(guest: Guest.new(name: Guest::EmptyName.new, email: Guest::EmailAddress.new('cheers@examples.com')), reservations: [])
  template = Email::Template.new('<h1>HTML version</h1>', 'This is text version of email.')

  subject { Email.new(options: { subject: 'Really sketchy subject line', template: template }, data: { itinerary: itinerary }) }

  it "responds to messages" do
    expect(subject).to respond_to(:render)
  end

  describe "#initialize" do
    it "accepts correct keywords" do
      expect(subject.method(:initialize).parameters).to eq([[:key, :options], [:key, :data]])
    end

    it "freezes the object" do
      expect(subject).to be_frozen
    end
  end
end
