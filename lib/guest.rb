class Guest

  EmptyName = Struct.new(:name) do
    def initialize
      super('ACC Facility User')
    end

    def formal
      name
    end

    def informal
      name
    end

    def to_s
      name
    end

    def to_name
      self
    end
  end

  OrganizationName = Struct.new(:name) do
    def formal
      name
    end

    def informal
      name
    end

    def to_s
      name
    end

    def to_name
      self
    end
  end

  IndividualName = Struct.new(:first, :last) do
    def full
      "#{first} #{last}"
    end

    def formal
      full
    end

    def informal
      first
    end

    def to_s
      full
    end

    def to_name
      self
    end
  end

  EmailAddress = Struct.new(:raw) do
    def initialize(*args)
      super(*args)
      self.raw = raw.downcase
    end

    def to_s
      raw
    end

    def to_email
      self
    end
  end

  attr_reader :name, :email

  def initialize(name: Guest::EmptyName.new, email:)
    @name = name.to_name
    @email = email.to_email
    freeze
  end

  def to_guest
    self
  end
end
