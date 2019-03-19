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

ENVIRONMENT = ENV['MAILER_ENV'] || 'development'
CONFIG = YAML.load_file(CONFIG_PATH)[ENVIRONMENT].to_dot

Mail.defaults do
  delivery_method :smtp, { address: CONFIG.smtp.host,
                           port: CONFIG.smtp.port,
                           user_name: CONFIG.smtp.user,
                           password: CONFIG.smtp.password }
end

CONFIG.sending_options.each do |option|
  email_template = Email::Template.new(option.template.html, option.template.text)
  visits = Merlin::visits_from_days(db: CONFIG.db, delay: option.delay)
  emails = visits.map { |visit| Email.new(visit: visit, subject: option.subject, template: email_template) }

  emails.each do |email|
    if Merlin::hut_survey_for_visit(db: CONFIG.db, email: email)
      puts 'Email skipped because hut survey already exists.'
      next
    end

    Merlin::deliver_survey_email(db: CONFIG.db, email: email)

  end

  puts "No visits were found #{option.delay >= 0 ? 'ending' : 'starting'} on #{Date::today - option.delay}." if emails.empty?

end

