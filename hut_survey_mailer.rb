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

require './merlin'
require 'hash_dot'
require 'pathname'
require 'pg'
require 'sneakers'
require 'yaml'

CONFIG_PATH = Pathname(__dir__).join('config', 'config.yml')

ENVIRONMENT = ENV['MAILER_ENV'] || 'development'
CONFIG = YAML.load_file(CONFIG_PATH)[ENVIRONMENT].to_dot

visits = Merlin::visits_from_days(db: CONFIG.db, delay: CONFIG.sending_options.delay)

visits.each { |visit| puts visit.guest.name.formal }
