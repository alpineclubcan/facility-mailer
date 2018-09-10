class Visit

  Facility = Struct.new(:code, :name) do
    def to_facility
      self
    end
  end

  attr_reader :facility, :start_date, :number_of_nights

  def initialize(facility:, start_date: nil, number_of_nights: 1)
    @facility = facility.to_facility
    @start_date = start_date
    @number_of_nights = number_of_nights
  end

end
