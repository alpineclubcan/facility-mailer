class Itinerary

  Facility = Struct.new(:code, :name) do
    def to_facility
      self
    end
  end

  Reservation = Struct.new(:facility, :bookings) do
    def congruent?
      bookings.map { |booking| booking.number_of_users }.uniq.length == 1
    end

    def continuous?
      # reservation has no gaps
    end

    def to_reservation
      self
    end
  end

  Booking = Struct.new(:date, :number_of_users) do
    def to_booking
      self
    end
  end

  attr_reader :guest, :reservations

  def initialize(:guest, :reservations)
    @guest = guest.to_guest
    @reservations = reservations.to_a
    freeze
  end

  def to_itinerary
    self
  end

end
