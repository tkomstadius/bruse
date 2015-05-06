if type "rvm -v" > /dev/null 2>&1; then
  echo "Install ruby before continuing"
  echo "Perhaps by running this: curl -sSL https://get.rvm.io | bash -s stable --rails"
  exit
fi

if type "psql -V" > /dev/null 2>&1; then
  echo "Install psql before continuing"
  exit
fi

# setup psql credentials
PASSWORD=$(date +%s | sha256sum | base64 | head -c 32 ; echo)
sudo su - postgres -c "psql -c \"CREATE USER cool_bruse WITH PASSWORD '$PASSWORD' SUPERUSER\""
sudo su - postgres -c "psql -c \"CREATE DATABASE bruse_production WITH OWNER cool_bruse\""
curl -L https://github.com/tkomstadius/bruse/archive/develop.tar.gz | tar xz --strip-components=1

# Update the database config filefile
printf "production:\n  <<: *default\n  username: cool_bruse\n  password: $PASSWORD\n  database: bruse_production" >> config/database.yml

# run the setup file
bundle install
rake db:setup

# Generate a random key
export SECRET_KEY_BASE=$(date +%s | sha256sum | base64 | head -c 32 ; echo)

printf "Devise.setup do |config|\n\n  config.secret_key = 'a9050a40481fe4f8d864147fc7c7e56a2bd5dfbeb079dff3c05b745286da9315ed9a40e511cf83c57db26deaec4949cdc6ca8cef1e530dd337edb3c8184a1f31'\n\n  config.mailer_sender = 'please-change-me-at-config-initializers-devise@example.com'\n\n  require 'devise/orm/active_record'\n\n  config.case_insensitive_keys = [ :email ]\n\n  config.strip_whitespace_keys = [ :email ]\n\n  config.skip_session_storage = [:http_auth]\n\n  config.stretches = Rails.env.test? ? 1 : 10\n\n  config.allow_unconfirmed_access_for = 3.days\n\n  config.reconfirmable = true\n\n  config.expire_all_remember_me_on_sign_out = true\n\n  config.password_length = 8..128\n\n  config.reset_password_within = 6.hours\n\n  config.sign_out_via = :delete\n\n" > config/initializers/devise.rb

promptForDropbox(){
  echo -n "Enter your DROPBOX_KEY: "
  read db_key
  export DROPBOX_KEY=$db_key
  printf "DROPBOX_KEY: '$db_key'\n" >> config/application.yml
  echo -n "Enter your DROPBOX_SECRET: "
  read db_secret
  export DROPBOX_SECRET=$db_secret
  printf "DROPBOX_SECRET: '$db_secret'\n" >> config/application.yml
  thirdParty=true

  printf "config.omniauth :dropbox_oauth2, ENV['DROPBOX_KEY'], ENV['DROPBOX_SECRET']\n" >> config/initializers/devise.rb
}
while true; do
  read -p "Do you want to use Dropbox? (y/n)" yn
  case $yn in
    [Yy]* ) promptForDropbox; break;;
    [Nn]* ) break;;
    * ) echo "Please answer yes or no.";;
  esac
done

promptForDrive(){
  echo -n "Enter your DRIVE_KEY: "
  read d_key
  export DRIVE_KEY=$d_key
  printf "DRIVE_KEY: '$d_key'\n" >> config/application.yml
  echo -n "Enter your DRIVE_SECRET: "
  read d_secret
  export DRIVE_SECRET=$d_secret
  printf "DRIVE_SECRET: '$d_secret'\n" >> config/application.yml
  thirdParty=true

  printf "config.omniauth :google_oauth2, ENV['DRIVE_KEY'], ENV['DRIVE_SECRET'],\n{ :scope => 'email, profile, https://www.googleapis.com/auth/drive'}\n" >> config/initializers/devise.rb
}
while true; do
  read -p "Do you want to use Google Drive? (y/n)" yn
  case $yn in
    [Yy]* ) promptForDrive; break;;
    [Nn]* ) break;;
    * ) echo "Please answer yes or no.";;
  esac
done

printf "end" >> config/initializers/devise.rb

if [ "$thirdParty" = true ] ; then
  echo "You can allways change your codes by editing the config/application.yml."
fi

if type "foreman -v" > /dev/null 2>&1; then
  sudo apt-get install ca-certificates
  wget https://apt.puppetlabs.com/puppetlabs-release-trusty.deb
  dpkg -i puppetlabs-release-trusty.deb

  echo "deb http://deb.theforeman.org/ trusty 1.8" > /etc/apt/sources.list.d/foreman.list
  echo "deb http://deb.theforeman.org/ plugins 1.8" >> /etc/apt/sources.list.d/foreman.list
  wget -q http://deb.theforeman.org/pubkey.gpg -O- | apt-key add -

  sudo apt-get update && apt-get install foreman-installer
  foreman-installer
fi
echo "web: rails s -e production" > Procfile

foreman start
