require 'email'
require 'visit'
require 'guest'

describe Email do
  FACILITY = Visit::Facility.new("CH", "Canmore Clubhouse")
  VISIT = Visit.new(reservation_id: 0, facility: FACILITY, guest: Guest.new(email: Guest::EmailAddress.new('mountain@acc.net'), name: Guest::EmptyName.new), number_of_nights: 5)
  TEMPLATE = Email::Template.new('<h1>HTML version</h1>', 'This is text version of email.')

  subject { Email.new(options: { subject: 'Really sketchy subject line', template: TEMPLATE }, data: { visit: VISIT }) }

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
