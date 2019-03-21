#!/usr/bin/env ruby 
# Hut Survey Mailer
#
# Version 0.2.2
#
# The Alpine Club of Canada is a non-profit organization that promotes
# mountain culture and involvement in mountain activities. The Club manages
# and handles bookings for over 30 backcountry facilities.
#
# This application emails facility experience surveys to guests at a given
# interval after their stay has completed.
#
# Usage:
#
# Run the script from the command line or through a job scheduling service such as cron.
# All parameters enter through the `config/config.yml` file. If it doesn't exist, copy the 
# `config/config.defaults.yml` file over and make sure to set your production variables.
#

# Third-party requires
require 'pathname'
require 'hash_dot'
require 'pg'
require 'yaml'

# Local requires
require Pathname(__dir__).join('merlin.rb')
require Pathname(__dir__).join('lib', 'email.rb')

CONFIG_PATH = Pathname(__dir__).join('config', 'config.yml')
FACILITIES_PATH = Pathname(__dir__).join('config', 'facilities.yml')
TEMPLATES_DIR = Pathname(__dir__).join('templates')

ENVIRONMENT = ENV['MAILER_ENV'] || 'development'
CONFIG = YAML.load_file(CONFIG_PATH)[ENVIRONMENT].to_dot

FACILITIES = YAML.load_file(FACILITIES_PATH).to_dot.list

Mail.defaults do
  delivery_method :smtp, { address: CONFIG.smtp.host,
                           port: CONFIG.smtp.port,
                           user_name: CONFIG.smtp.user,
                           password: CONFIG.smtp.password }
end

def production?
  ENVIRONMENT == 'production'
end

def template(name:, format:)
  File.read("#{TEMPLATES_DIR}/#{name}.#{format.to_s}.erb")
end

CONFIG.sending_options.each do |option|
  next if option.fetch('skip', false) 

  email_template = Email::Template.new(template(name: option.template, format: :html), template(name: option.template, format: :txt))
  visits = Merlin::visits_from_days(db: CONFIG.db, delay: option.delay)

  emails = visits.map { |visit| Email.new(options: { to: visit.guest.email.to_s, subject: option.subject, template: email_template }.to_dot, data: { visit: visit }.to_dot) }

  emails.each do |email|
    if Merlin::email_for_visit(db: CONFIG.db, email: email)
      puts 'Email skipped because one has already been sent.'
      next
    end

    Merlin::deliver_survey_email(db: CONFIG.db, email: email, log_email: production?)

  end

  puts "No visits were found #{option.delay >= 0 ? 'ending' : 'starting'} on #{Date::today - option.delay}." if emails.empty?

end

