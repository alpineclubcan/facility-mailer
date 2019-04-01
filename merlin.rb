# Hide fugly procedural database access code in here!

require Pathname(__dir__).join('lib', 'guest.rb')
require Pathname(__dir__).join('lib', 'itinerary.rb')

module Merlin
  Invoice = Struct.new(:id, :contact_id, :contact_email_address)
  LockCombination = Struct.new(:value, :valid_from, :valid_to)

  def self.get_invoices_with_stays_beginning(db:, date:)
    lambda do
      invoices = []

      begin
        conn = PG::connect(db)

        res = conn.exec_params('SELECT * FROM get_invoices_with_stays_beginning($1::date)', [date.to_date])

        invoices += res.map(&ROW_TO_INVOICE)
      rescue PG::Error => e
        puts "An error of type #{e.class} occurred at #{fnow} while attempting to get invoices from beginning.\n#{e.message}"
        raise
      ensure
        conn&.close
      end
       
      invoices
    end
  end

  def self.get_invoices_with_stays_ending(db:, date:)
    lambda do
      invoices = []

      begin
        conn = PG::connect(db)

        res = conn.exec_params('SELECT * FROM get_invoices_with_stays_ending($1::date)', [date.to_date])

        invoices += res.map(&ROW_TO_INVOICE)
      rescue PG::Error => e
        puts "An error of type #{e.class} occurred at #{fnow} while attempting to get invoices from ending.\n#{e.message}"
        raise
      ensure
        conn&.close
      end
      
      invoices
    end
  end

  def self.get_reservations_for_invoice(db:, invoice_id:)
    lambda do
      reservations = []

      begin
        conn = PG::connect(db)

        res = conn.exec_params('SELECT * FROM get_itinerary_for_invoice($1::integer)', [invoice_id.to_i])

        reservations =+ ROWS_TO_RESERVATIONS.call(res)

      rescue PG::Error => e
        puts "An error of type #{e.class} occurred at #{fnow} while attempting to get itinerary for invoice.\n#{e.message}"
        raise
      ensure
        conn&.close
      end

      reservations
    end
  end

  def self.get_lock_combinations_for_date(db:, facility_code:, date:)
    lambda do
      combinations = []

      begin
        conn = PG::connect(db)

        res = conn.exec_params('SELECT * FROM get_lock_combinations_for_stay($1::text, $2::date)', [invoice_id.to_i])

        combinations += res.map(&ROW_TO_COMBINATION)
      rescue PG::Error => e
        puts "An error of type #{e.class} occurred at #{fnow} while attempting to get lock combinations.\n#{e.message}"
        raise
      ensure
        conn&.close
      end

      combinations
    end
  end

  def self.itineraries_from_delay(db:, delay:)
    search_date = Date.today + delay.to_i

    calls = []
    itineraries = []

    calls << get_invoices_with_stays_beginning(search_date) if delay.positive?
    calls << get_invoices_with_stays_ending(search_date) if delay.negative?
    calls += [get_invoices_with_stays_ending(search_date), get_invoices_with_stays_ending(search_date)] if delay.zero?

    calls.each do |proc|
      itineraries += proc.call
    end

    itineraries
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

  ROW_TO_INVOICE = proc { |row| Invoice.new(row['invoice_id'], row['contact_id'], row['contact_email_address']) }
  ROW_TO_COMBINATION = proc { |row| LockCombination.new(row['combination'], row['valid_from'], row['valid_to']) }
  ROW_TO_BOOKING = proc { |row| Itinerary::Booking.new(row['stay_date'], row['no_users']) }
  ROWS_TO_RESERVATIONS = proc do |rows|
    grouped_bookings = rows.group_by { |row| Itinerary::Facility.new(row['facility_code'], row['facility_name']) }
    grouped_bookings.map do |key, value|
      Itinerary::Reservation.new(key, value.map(&ROW_TO_BOOKING))
    end
  end

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
