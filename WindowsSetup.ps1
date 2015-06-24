Import-Module BitsTransfer

# Download the railsinstaller.

$rails_installer = "https://s3.amazonaws.com/railsinstaller/Windows/railsinstaller-3.1.0.exe"
$download_path = "C:\Users\$([Environment]::UserName)\Downloads\railsinstaller-3.1.0.exe"

# Old slow way.
#Invoke-WebRequest $rails_installer -OutFile $download_path

# Faster method
Start-BitsTransfer $rails_installer $download_path

# Silently install railsinstaller.
$expr_string = "C:\Users\$([Environment]::UserName)\Downloads\railsinstaller-3.1.0.exe /verysilent /tasks=`"assocfiles,modpath`""
Invoke-Expression $expr_string -ErrorAction Stop

# Download the first of two SSL cert files
# Drop in the proper directory

$cert_file_1 = "https://raw.githubusercontent.com/rubygems/rubygems/master/lib/rubygems/ssl_certs/AddTrustExternalCARoot-2048.pem"
$ssl_path = "C:\RailsInstaller\Ruby2.1.0\lib\ruby\2.1.0\rubygems\ssl_certs\AddTrustExternalCARoot-2048.pem"

Invoke-WebRequest $cert_file_1 -OutFile $ssl_path

# Download the second of two SSL cert files
# Drop in the proper directory

$cert_file_2 = "http://curl.haxx.se/ca/cacert.pem"
$ssl_path = "C:\RailsInstaller\Ruby2.1.0\lib\ruby\2.1.0\rubygems\ssl_certs\cacert.pem"

Invoke-WebRequest $cert_file_2 -OutFile $ssl_path

# Set machine environment variable

[Environment]::SetEnvironmentVariable("SSL_CERT_FILE", "C:\RailsInstaller\Ruby2.1.0\lib\ruby\2.1.0\rubygems\ssl_certs\cacert.pem", "Machine")

# Reload Path
$env:Path = [Environment]::GetEnvironmentVariable("Path")

$get_rubygems = "gem install nokogiri barge"
Invoke-Expression $get_rubygems

# Download Script from GitHub
# Here is the RAW URL that you will need to download
# https://raw.githubusercontent.com/mpslanker/DigitalOcean-DDNS/master/do-ddns-update.rb
