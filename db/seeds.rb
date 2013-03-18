#def truncate_all_tables
  #conn = ActiveRecord::Base.connection
  #tables = conn.execute("show tables").map { |r| r[0] }
  #tables.delete "schema_migrations"
  #tables.each { |t| conn.execute("TRUNCATE #{t}") }
#end

def truncate_db_table(table)
  ActiveRecord::Base.connection.execute("TRUNCATE #{table}")
end

if Rails.env.development?
  truncate_db_table("delayed_jobs")
end

