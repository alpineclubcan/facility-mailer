require 'guest'

describe Guest do
  NAME = Guest::Name.new("Joan", "OfArc")
  EMAIL_ADDRESS = Guest::EmailAddress.new("death.by.sword@gmail.com")

  subject { Guest.new(name: NAME, email: EMAIL_ADDRESS) }

  it "responds to messages" do
    expect(subject).to respond_to(:name)
    expect(subject).to respond_to(:email)
  end

  describe "#initialize" do
    it "accepts correct keywords" do
      expect(subject.method(:initialize).parameters).to eq([[:keyreq, :name], [:keyreq, :email]])
    end

    it "correctly sets attributes accessed by messages" do
      expect(subject.name).to eq(NAME)
      expect(subject.email).to eq(EMAIL_ADDRESS)
    end

    it "results in a frozen object" do
      expect(subject).to be_frozen
    end
  end
end
