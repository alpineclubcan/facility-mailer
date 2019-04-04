class Itinerary

  Facility = Struct.new(:code, :name) do
    def to_facility
      self
    end
  end

  Reservation = Struct.new(:facility, :bookings) do
    def congruent?
      group_sizes.uniq.length == 1
    end

    def continuous?
      return true if bookings.length == 1

      dates = bookings.map(&BY_DATE).sort
      dates.each_cons(2).map { |earlier, later| (later - earlier).to_i.abs }.uniq == [1]
    end

    def first_night
      bookings.min_by(&BY_DATE).date
    end

    def last_night
      bookings.max_by(&BY_DATE).date
    end

    def departure_date
      last_night + 1
    end

    def group_sizes
      bookings.sort_by(&BY_DATE).map { |booking| booking.number_of_users }
    end

    def to_reservation
      self
    end

    private

    BY_DATE = proc { |booking| booking.date }
  end

  Booking = Struct.new(:date, :number_of_users) do
    def to_booking
      self
    end
  end

  attr_reader :guest, :reservations

  def initialize(guest:, reservations:)
    @guest = guest.to_guest
    @reservations = reservations.to_a.map { |res| res.to_reservation }
    freeze
  end

  def to_itinerary
    self
  end

end
