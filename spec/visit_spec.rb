require "visit"

describe Visit do

  # Construct minimum valid instance with only required keyword
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

  context "when object is minimal default instance" do
    it "responds to messages" do
      expect(subject).to respond_to(:facility)
      expect(subject).to respond_to(:start_date)
      expect(subject).to respond_to(:number_of_nights)
    end

    it "has a start_date equal to today" do
      expect(subject.start_date).to eq(Date.today)
    end

    it "has a number_of_nights equal to 1" do
      expect(subject.number_of_nights).to eq(1)
    end
  end
end
