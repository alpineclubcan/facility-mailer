class Guest

  Name = Struct.new(:first, :last) do
    def full
      "#{first} #{last}"
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

  def initialize(name:, email:)
    @name = name.to_name
    @email = email.to_email
    freeze
  end
end
