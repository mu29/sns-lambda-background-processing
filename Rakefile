require 'yaml'
require 'erb'
require 'active_record'

task :clean do
  system 'rm -rf .bundle vendor'
end

task :build do
  system 'mkdir -p lib'
  system 'docker build -t lambda-ruby2.5-mysql .'
  system 'docker run --rm -i -v $PWD:/var/task -w /var/task lambda-ruby2.5-mysql /bin/bash <<EOF
    cp /usr/lib64/mysql/* lib
    bundle install --deployment
  EOF'
  system 'rm -rf vendor'
  system 'docker run --rm -it -v $PWD:/var/task -w /var/task lambda-ruby2.5-mysql bundle install --deployment'
end

task :deploy do
  system 'rake build'
  system 'sls deploy'
end

namespace :db do
  config_erb = ERB.new(File.read('config/database.yml')).result
  db_config = YAML.load(config_erb)['default']
  db_config_admin = db_config.merge({
    database: 'mysql',
    schema_search_path: 'public'
  })

  desc 'Create the database'
  task :create do
    ActiveRecord::Base.establish_connection(db_config_admin)
    ActiveRecord::Base.connection.create_database(db_config['database'])
  end

  desc 'Migrate the database'
  task :migrate do
    ActiveRecord::Base.establish_connection(db_config)
    ActiveRecord::MigrationContext.new('db/migrate/', ActiveRecord::SchemaMigration).migrate
    Rake::Task['db:schema'].invoke
  end

  desc 'Drop the database'
  task :drop do
    ActiveRecord::Base.establish_connection(db_config_admin)
    ActiveRecord::Base.connection.drop_database(db_config['database'])
  end

  desc 'Create a db/schema.rb file that is portable against any DB supported by AR'
  task :schema do
    ActiveRecord::Base.establish_connection(db_config)
    require 'active_record/schema_dumper'
    filename = 'db/schema.rb'
    File.open(filename, 'w:utf-8') do |file|
      ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, file)
    end
  end
end
