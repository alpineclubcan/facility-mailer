# facility-mailer
Mails communications to facility users after their stay date has finished.


## Setup
The only thing that is required for setup is copying the `config/config.defaults.yml` over to `config/config.yml`. It is best to specify a configuration section for production. In order for the app to select the proper config structure, you must set the environment variable **MAILER_ENV** to be `test`, `development`, or `production`. Otherwise, the default of `development` will be used.
