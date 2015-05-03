if type "rvm -v" > /dev/null 2>&1; then
  echo "install ruby"
fi

if type "psql -V" > /dev/null 2>&1; then
  echo "install psql"
fi

# setup psql credentials
psql -c "CREATE USER bruse WITH PASSWORD 'kex2015'"
psql -c "CREATE DATABASE bruse_production WITH OWNER bruse"

curl -L https://github.com/tkomstadius/bruse/archive/master.tar.gz | tar xz --strip-components=1
bundle install

export SECRET_KEY_BASE=randomstring
# setup database.yml
rails s -e production
