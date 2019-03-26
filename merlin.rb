# Hide fugly procedural database access code in here!

require Pathname(__dir__).join('lib', 'guest.rb')
require Pathname(__dir__).join('lib', 'visit.rb')

module Merlin
  AHEAD_FUNC = 'get_visits_from_days_ahead'
  BEHIND_FUNC = 'get_visits_from_days_behind'

  def self.visits_from_days(db:, delay:)
    visits = []

    func = delay.to_i.positive? ? AHEAD_FUNC : BEHIND_FUNC

    begin
      conn = PG::connect(db)

      res = conn.exec_params("SELECT * FROM #{func}($1::integer)",
                             [delay.to_i.abs]
                            )

      res.each do |row|
        facility = Visit::Facility.new(row['facility_code'], row['facility_name'])

        email = Guest::EmailAddress.new(row['email_address'])

        guest = Guest.new(name: Guest::EmptyName.new, email: email)
        visit = Visit.new(reservation_id: row['reservation_id'].to_i, facility: facility, guest: guest, start_date: Date.parse(row['start_date']), number_of_nights: row['number_of_nights'])

        visits << visit
      end

    rescue PG::Error => e
      puts "An error of type #{e.class} occurred at #{fnow} while getting visits from the database.\n#{e.message}"
      raise
    ensure
      conn&.close
    end

    visits
  end

  def self.deliver_survey_email(db:, email:, log_email: false)
    message = email.render

    begin
      message.deliver!

      if message.bounced?
        puts "Email to #{email.options.to} bounced at #{fnow} and may not be delivered."
      else
        puts "Email successfully delivered to #{email.options.to} at #{fnow}."
      end

      log_email(db: db, email: email) if log_email

    rescue => e
      puts "An error of type #{e.class} occurred at #{fnow} while attempting to deliver the email.\n#{e.message}"
      raise
    end
  end

  def self.email_for_visit(db:, email:)
    record = nil
    visit = email.data.visit

    begin
      conn = PG::connect(db)

      res = conn.exec_params('SELECT * FROM get_hut_email_for_visit($1::varchar, $2::date, $3::varchar, $4::varchar)',
                             [visit.guest.email, visit.end_date, visit.facility.code, email.options.template.name]
                            )
      hut_survey = res.first

    rescue PG::Error => e
      puts "An error of type #{e.class} occurred at #{fnow} while getting email from database.\n#{e.message}"
      raise
    ensure
      conn&.close
    end

    record
  end

  private

  DATE_FORMAT = '%H:%M:%S %Y-%m-%d'.freeze

  def self.log_email(db:, email:)
    begin
      conn = PG::connect(db)

      visit = email.data.visit
      
      res = conn.exec_params(
        'INSERT INTO public.hut_email(reservation_id, email, end_date, facility_code, date_sent, template) VALUES($1::integer, $2::varchar, $3::date, $4::varchar, $5::date, $6::varchar)', 
        [visit.reservation_id, visit.guest.email, visit.end_date, visit.facility.code, Date::today, email.options.template.name]
      )

      puts "Email logged for #{email.options.to} at #{fnow}."

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
