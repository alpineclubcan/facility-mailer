require "visit"

describe Visit do

  subject { Visit.new(facility: Visit::Facility.new("CH", "Canmore Clubhouse")) }

  describe ".initialize" do
    context "when initialization is successful" do
      it "accepts the correct keywords" do
        # Shitty workaround for rspec behavior with keyword exposure in :new with respond_to matcher
        expect(subject.method(:initialize).parameters).to eq([[:keyreq, :facility], [:key, :start_date], [:key, :number_of_nights]])
      end
    end

    context "when invalid facility is given" do
      it "fails to when an invalid facility is given" do
        expect { Visit.new(facility: nil) }.to raise_error(NoMethodError)
      end
    end
  end

  context "when object is instance" do
    it "responds to messages" do
      expect(subject).to respond_to(:facility)
      expect(subject).to respond_to(:start_date)
      expect(subject).to respond_to(:number_of_nights)
    end
  end
end
