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

require 'yaml'
require 'pg'
require 'sneakers'

module HutSurveyMailer
  def self.load_config(config_path:)
  end

  def self.load_template(html_path:, text_path:)
  end
end

begin
  conn = PG.connect(dbname: 'name', user: 'user', password: 'password')

rescue PG::Error => e
  puts e.message

ensure
  conn.close if conn

end



