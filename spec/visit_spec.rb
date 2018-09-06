require "visit"

describe Visit do
  describe "when object is initialized" do
    it "responds to messages" do
      expect(subject).to respond_to(:new)
      expect(subject).to respond_to(:facility)
    end
  end
end
