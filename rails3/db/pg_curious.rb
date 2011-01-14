gem "pg"

run "bundle install"

# For if you don't use 'root' and a blank password. This recipe wants to know your username & password.
pg_user =     ask("Local (development) postgresql username:")
pg_password = ask("Local (development) postgresql password:")

if no?("Use same username & password for test environment?")
  test_pg_user =      ask("Test environment postgresql username:")
  test_pg_password =  ask("Test environment postgresql password:")
else
  test_pg_user =      pg_user
  test_pg_password =  pg_password
end

if no?("Use same username & password for production environment?")
  production_pg_user =      ask("Production environment postgresql username:")
  production_pg_password =  ask("Production environment postgresql password:")
else
  production_pg_user =      pg_user
  production_pg_password =  pg_password
end

file 'config/database.yml' do
  %{
development: &defaults
  adapter:  postgresql
  encoding: unicode
  database: #{project_name}_development
  pool: 5
  username: #{pg_user}
  password: #{pg_password}


# Warning: The database defined as "test" will be erased and
# re-generated from your development database when you run "rake".
# Do not set this db to the same as development or production.
test:
  <<:       *defaults
  database: #{project_name}_test
  username: #{test_pg_user}
  password: #{test_pg_password}

production:
  >>:       *defaults
  database: #{project_name}_production
  username: #{production_pg_user}
  password: #{production_pg_password}
}
end

FileUtils.copy "config/database.yml", "config/database.yml.example"

if yes?("Create databases using rake db:create:all?")
  rake "db:create:all"
end