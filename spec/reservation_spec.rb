require 'itinerary'
require 'date'

describe Itinerary::Reservation do
  FACILITY = Itinerary::Facility.new("CH", "Canmore Clubhouse")

  describe '#continuous?' do
    it 'returns true with consecutive dates' do
      CONTINUOUS = Itinerary::Reservation.new(FACILITY, [Itinerary::Booking.new(Date.today, 1), Itinerary::Booking.new(Date.today - 1, 1), Itinerary::Booking.new(Date.today - 2, 1)])

      expect(CONTINUOUS).to be_continuous
    end

    it 'returns false with non-consecutive dates' do
      NOT_CONTINUOUS = Itinerary::Reservation.new(FACILITY, [Itinerary::Booking.new(Date.today, 1), Itinerary::Booking.new(Date.today - 3, 1), Itinerary::Booking.new(Date.today - 1, 1)])

      expect(NOT_CONTINUOUS).not_to be_continuous
    end
  end

  describe '#congruent' do
    it 'returns true with same number of users' do
      CONGRUENT = Itinerary::Reservation.new(FACILITY, [Itinerary::Booking.new(Date.today, 1), Itinerary::Booking.new(Date.today - 1, 1), Itinerary::Booking.new(Date.today - 2, 1)])

      expect(CONGRUENT).to be_congruent
    end

    it 'returns false with different number of users' do
      NOT_CONGRUENT = Itinerary::Reservation.new(FACILITY, [Itinerary::Booking.new(Date.today, 1), Itinerary::Booking.new(Date.today - 1, 3), Itinerary::Booking.new(Date.today - 2, 2)])

      expect(NOT_CONGRUENT).not_to be_congruent
    end
  end

end

