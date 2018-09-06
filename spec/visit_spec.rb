require "visit"

describe Visit do

  describe ".initialize" do
    it "correctly responds to :new" do
      expect(described_class).to respond_to(:new).with_keywords(:facility)
    end
  end

  context "when object is instance" do

    subject { Visit.new(facility: Visit::Facility.new("CH", "Canmore Clubhouse")) }

    it "responds to messages" do
      expect(subject).to respond_to(:facility)
      expect(subject).to respond_to(:start_date)
      expect(subject).to respond_to(:number_of_nights)
    end
  end
end
