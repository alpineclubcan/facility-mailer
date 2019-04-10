require 'itinerary'
require 'guest'

describe Itinerary do
  before(:each) do
    facility = Itinerary::Facility.new("CH", "Canmore Clubhouse")
    guest = Guest.new(email: Guest::EmailAddress.new('family@darpa.com'), name: Guest::IndividualName.new('James', 'Bond'))
    reservations = [Itinerary::Reservation.new()]
  end
end
