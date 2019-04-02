# Hide fugly procedural database access code in here!

require Pathname(__dir__).join('lib', 'guest.rb')
require Pathname(__dir__).join('lib', 'visit.rb')

module Merlin
  def self.visits_from_days(db:, delay:)
    visits = []

    begin
      conn = PG::connect(db)

      res = conn.exec_params("SELECT * FROM get_visits_from_days($1::integer)",
                             [delay.to_i]
                            )

      res.each do |row|
        facility = Visit::Facility.new(row['facility_code'], row['facility_name'])

        email = Guest::EmailAddress.new(row['email_address'])

        guest = Guest.new(name: Guest::EmptyName.new, email: email)
        visit = Visit.new(reservation_id: row['reservation_id'].to_i, facility: facility, guest: guest, start_date: Date.parse(row['start_date']), number_of_nights: row['number_of_nights'])

        visits << visit
      end

    rescue PG::Error => e
      puts "An error of type #{e.class} occurred at #{fnow} while getting visits from the database."

    ensure
      conn&.close
    end

    visits
  end


  def self.deliver_survey_email(db:, email:)
    message = email.render

    begin
      message.deliver!

      if message.bounced?
        puts "Email to #{email.visit.guest.email} bounced at #{fnow} and may not be delivered."
      else
        puts "Email successfully delivered to #{email.visit.guest.email} at #{fnow}."
      end

      log_email_for_visit(db: db, email: email)

    rescue => e
      puts "An error of type #{e.class} occurred at #{fnow} while attempting to deliver the survey email.\n#{e.backtrace}"
      raise
    end
  end

  def self.hut_survey_for_visit(db:, email:)
    hut_survey = nil
    visit = email.visit

    begin
      conn = PG::connect(db)

      res = conn.exec_params('SELECT * FROM get_hut_survey_for_visit($1::varchar, $2::date, $3::varchar)',
                             [visit.guest.email, visit.end_date, visit.facility.code]
                            )
      hut_survey = res.first

    rescue PG::Error => e
      puts "An error of type #{e.class} occurred at #{fnow} while getting hut survey from database."

    ensure
      conn&.close
    end

    hut_survey
  end

  private

  DATE_FORMAT = '%H:%M:%S %Y-%m-%d'.freeze

  def self.log_email_for_visit(db:, email:)
    begin
      conn = PG::connect(db)

      visit = email.visit
      
      res = conn.exec_params(
        'INSERT INTO public.hut_survey(reservation_id, email, end_date, facility_code, date_sent) VALUES($1::integer, $2::varchar, $3::date, $4::varchar, $5::date)', 
        [visit.reservation_id, visit.guest.email, visit.end_date, visit.facility.code, Date::today]
      )

      puts "Email logged for #{email.visit.guest.email} at #{fnow}."

    rescue PG::Error => e  
      puts "An error of type #{e.class} occurred at #{fnow} while logging survey to the database."
      
    ensure
      conn&.close
    end
  end

  def self.fnow
    now.strftime(DATE_FORMAT)
  end
  
  def self.now
    Time::now
  end
end
