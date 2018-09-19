require "date"

class Visit

  Facility = Struct.new(:code, :name) do
    def to_facility
      self
    end
  end

  attr_reader :facility, :guest, :start_date, :number_of_nights

  def initialize(facility:, guest:, start_date: Date.today, number_of_nights: 1)
    @facility = facility.to_facility
    @guest = guest.to_guest
    @start_date = start_date
    @number_of_nights = number_of_nights.to_i
    freeze
  end

  def end_date
    start_date + number_of_nights
  end

  def finished?
    end_date < Date.today
  end

  def to_visit
    self
  end

end
