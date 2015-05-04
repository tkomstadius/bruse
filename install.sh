if type "rvm -v" > /dev/null 2>&1; then
  echo "Install ruby before continuing"
  exit
fi

if type "psql -V" > /dev/null 2>&1; then
  echo "Install psql before continuing"
  exit
fi

# setup psql credentials
psql -c "CREATE USER bruse WITH PASSWORD 'kex2015'"
psql -c "CREATE DATABASE bruse_production WITH OWNER bruse"

curl -L https://github.com/tkomstadius/bruse/archive/master.tar.gz | tar xz --strip-components=1

# run the setup file
./bin/setup

# Generate a random key
export SECRET_KEY_BASE=$(date +%s | sha256sum | base64 | head -c 32 ; echo)

promptForDropbox(){
  echo "Enter your DROPBOX_KEY: "
  read db_key
  export DROPBOX_KEY=$db_key
  printf "DROPBOX_KEY: '$db_key'\n" >> config/application.yml
  echo "Enter your DROPBOX_SECRET: "
  read db_secret
  export DROPBOX_SECRET=$db_secret
  printf "DROPBOX_SECRET: '$db_secret'\n" >> config/application.yml
  thirdParty=true
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
  echo "Enter your DRIVE_KEY: "
  read d_key
  export DRIVE_KEY=$d_key
  printf "DRIVE_KEY: '$d_key'\n" >> config/application.yml
  echo "Enter your DRIVE_SECRET: "
  read d_secret
  export DRIVE_SECRET=$d_secret
  printf "DRIVE_SECRET: '$d_secret'\n" >> config/application.yml
  thirdParty=true
}
while true; do
  read -p "Do you want to use Google Drive? (y/n)" yn
  case $yn in
    [Yy]* ) promptForDrive; break;;
    [Nn]* ) break;;
    * ) echo "Please answer yes or no.";;
  esac
done

if [ "$thirdParty" = true ] ; then
  echo "You can allways change your codes by editing the config/application.yml."
fi

rails s -e production
