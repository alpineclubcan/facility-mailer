require 'guest'

describe Guest do
  name = Guest::IndividualName.new("Joan", "OfArc")
  email_address = Guest::EmailAddress.new("death.by.sword@gmail.com")

  subject { Guest.new(name: name, email: email_address) }


  it "responds to messages" do
    expect(subject).to respond_to(:name)
    expect(subject).to respond_to(:email)
  end

  describe "#initialize" do
    it "accepts correct keywords" do
      expect(subject.method(:initialize).parameters).to eq([[:keyreq, :email], [:key, :name]])
    end

    it "correctly sets attributes accessed by messages" do
      expect(subject.name).to eq(name)
      expect(subject.email).to eq(email_address)
    end

    it "results in a frozen object" do
      expect(subject).to be_frozen
    end
  end
end
