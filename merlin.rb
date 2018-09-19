# Hide fugly procedural database access code in here!

require './lib/guest'
require './lib/visit'

module Merlin
  def self.visits_from_days(db:, delay:)
    visits = []

    begin
      conn = PG.connect(CONFIG.db)

      res = conn.exec_params("SELECT * FROM get_visits_from_days(#{CONFIG.sending_options.delay})")

      res.each do |row|
        facility = Visit::Facility.new(row['facility_code'], row['facility_name'])

        email = Guest::EmailAddress.new(row['email_address'])

        guest = Guest.new(name: Guest::EmptyName.new, email: email)
        visit = Visit.new(facility: facility, guest: guest, start_date: row['start_date'], number_of_nights: row['number_of_nights'])

        visits << visit
      end

    rescue PG::Error => e
      puts e.message

    ensure
      conn&.close
    end

    visits
  end
end
