# DigitalOcean-DDNS
A script for updating Digital Ocean DNS for use as DDNS.  Requires the following 3rd-party gems: Barge &amp; Nokogiri

### Instructions
This file can be used as a scirpt by running it with /bin/env/ruby do-ddns-update.rb or it can be used as a library.
Before doing so update the script with your DO APIv2 token, domain, the record you wish to update, and its type.
These values are located near the top of the script:
TOKEN = '<token>'
DOMAIN = '<domain>'
RECORD = '<record>'
RECORD_TYPE  = '<record type>'

** Note that it is not considered best practice to store your API keys in the file that could potentially get published. You may want to store it as an environment variable have set token as so: TOKEN = ENV["API_KEY"]

After this you should be able to run the script via command line "ruby do-ddns-update.rb" and see the changes on the DNS portal of digital oceans site.  If it has worked correctly you can use this with your favorite launch daemon or task scheduler to run automatically.
