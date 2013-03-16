# -*- coding: utf-8 -*-

def truncate_db_table(table)
  ActiveRecord::Base.establish_connection
  ActiveRecord::Base.connection.execute("TRUNCATE #{table}")
end


truncate_db_table("delayed_jobs")

