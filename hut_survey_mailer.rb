#!/usr/bin/env ruby 
# Hut Survey Mailer
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
require Pathname(__dir__).join('lib', 'survey_email.rb')

CONFIG_PATH = Pathname(__dir__).join('config', 'config.yml')

ENVIRONMENT = ENV['MAILER_ENV'] || 'development'
CONFIG = YAML.load_file(CONFIG_PATH)[ENVIRONMENT].to_dot

HTML_TEMPLATE_PATH = Pathname(__dir__).join(CONFIG.template.html)
TEXT_TEMPLATE_PATH = Pathname(__dir__).join(CONFIG.template.text)

EMAIL_TEMPLATE = SurveyEmail::Template.new(File.read(HTML_TEMPLATE_PATH), File.read(TEXT_TEMPLATE_PATH))

Mail.defaults do
  delivery_method :smtp, { address: CONFIG.smtp.host,
                           port: CONFIG.smtp.port,
                           user_name: CONFIG.smtp.user,
                           password: CONFIG.smtp.password }
end

visits = Merlin::visits_from_days(db: CONFIG.db, delay: CONFIG.sending_options.delay)

emails = visits.map { |visit| SurveyEmail.new(visit: visit, template: EMAIL_TEMPLATE).render }

emails.each { |msg| msg.deliver! }

