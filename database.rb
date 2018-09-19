# Hide fugly procedural database access code in here!
require './lib/visit'
require './lib/guest'

module Merlin
  def self.visits_from_days(db:, delay:)
    visits = []

    begin
      conn = PG.connect(db)

      res = conn.exec_params("SELECT * FROM get_visits_from_days(#{delay})")

      res.each do |row|
        facility = Visit::Facility.new(row['facility_code'], row['facility_name'])
        visit = Visit.new(facility: facility)

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
