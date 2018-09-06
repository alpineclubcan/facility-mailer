class Visit

  Facility = Struct.new(:code, :name) do
    def to_facility
      self
    end
  end

  attr_reader :facility

  def initialize
  end

end
