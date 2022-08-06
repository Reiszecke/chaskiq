#!/bin/bash -xue
# https://stackoverflow.com/a/73252801/2161301
# Create extensions in the schema where Heroku requires them to be created
# The plpgsql extension has already been created before this script is run
heroku pg:psql -a $HEROKU_APP_NAME -c 'create extension if not exists citext schema heroku_ext'
heroku pg:psql -a $HEROKU_APP_NAME -c 'create extension if not exists pg_stat_statements schema heroku_ext'

# Remove enable_extension statements from schema.rb before loading it, since
# even 'create extension if not exists' fails when the schema is not heroku_ext
mv db/schema.rb{,.orig}
grep -v enable_extension db/schema.rb.orig > db/schema.rb
rails db:schema:load