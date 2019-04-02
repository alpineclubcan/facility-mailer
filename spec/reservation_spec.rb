require 'itinerary'
require 'date'

describe Itinerary::Reservation do
  facility = Itinerary::Facility.new("CH", "Canmore Clubhouse")
describe '#continuous?' do
    it 'returns true with consecutive dates' do
      CONTINUOUS = Itinerary::Reservation.new(facility, [Itinerary::Booking.new(Date.today, 1), Itinerary::Booking.new(Date.today - 1, 1), Itinerary::Booking.new(Date.today - 2, 1)])

      expect(CONTINUOUS).to be_continuous
    end

    it 'returns false with non-consecutive dates' do
      NOT_CONTINUOUS = Itinerary::Reservation.new(facility, [Itinerary::Booking.new(Date.today, 1), Itinerary::Booking.new(Date.today - 3, 1), Itinerary::Booking.new(Date.today - 1, 1)])

      expect(NOT_CONTINUOUS).not_to be_continuous
    end
  end

  describe '#congruent' do
    it 'returns true with same number of users' do
      CONGRUENT = Itinerary::Reservation.new(facility, [Itinerary::Booking.new(Date.today, 1), Itinerary::Booking.new(Date.today - 1, 1), Itinerary::Booking.new(Date.today - 2, 1)])

      expect(CONGRUENT).to be_congruent
    end

    it 'returns false with different number of users' do
      NOT_CONGRUENT = Itinerary::Reservation.new(facility, [Itinerary::Booking.new(Date.today, 1), Itinerary::Booking.new(Date.today - 1, 3), Itinerary::Booking.new(Date.today - 2, 2)])

      expect(NOT_CONGRUENT).not_to be_congruent
    end
  end

  describe '#first_night' do
    it 'returns the correct date' do
      first_date = Date.parse('2019-03-03') 
      last_date = Date.parse('2019-03-04')

      bookings = [Itinerary::Booking.new(last_date, 2), Itinerary::Booking.new(first_date, 2)]

      reservation = Itinerary::Reservation.new(facility, bookings)

      expect(reservation.first_night).to eq(first_date)
    end
  end

  describe '#last_night' do
    it 'returns the correct date' do
      first_date = Date.parse('2019-03-03') 
      last_date = Date.parse('2019-03-04')

      bookings = [Itinerary::Booking.new(first_date, 2), Itinerary::Booking.new(last_date, 2)]

      reservation = Itinerary::Reservation.new(facility, bookings)

      expect(reservation.last_night).to eq(last_date)
    end
  end

  describe '#departure_date' do
    it 'returns the correct date' do
      first_date = Date.parse('2019-03-03') 
      last_date = Date.parse('2019-03-04')
      departure_date = Date.parse('2019-03-05')

      bookings = [Itinerary::Booking.new(first_date, 2), Itinerary::Booking.new(last_date, 2)]

      reservation = Itinerary::Reservation.new(facility, bookings)

      expect(reservation.departure_date).to eq(departure_date)
    end
  end

end

