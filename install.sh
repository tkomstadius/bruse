if type "rvm -v" > /dev/null 2>&1; then
  echo "install ruby"
fi

if type "psql -V" > /dev/null 2>&1; then
  echo "install psql"
fi

# setup psql credentials

curl -L https://github.com/tkomstadius/bruse/archive/master.tar.gz | tar xz --strip-components=1
bundle install
rails s
