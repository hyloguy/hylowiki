# hylowiki
# GA WDI Project 1
# Author: Michael N. Rubinstein

require 'sqlite3'

class LoadTestData

    DB_FILE = 'hylowiki.db'

    def initialize
        delete_database_if_it_exists
        connect_to_database             
        configure_database
        load_schema
        load_data
    end

    private

    def delete_database_if_it_exists
        if File.exist? DB_FILE
            File.delete DB_FILE
        end
    end

    def connect_to_database
        @db = SQLite3::Database.new(DB_FILE)
    end

    def configure_database
        @db.execute 'PRAGMA foreign_keys = true;'
        @db.results_as_hash = true
    end

    def load_schema
        @db.execute_batch File.read('scripts/schema.sql')
    end

    def load_data
        @db.execute_batch File.read('scripts/data.sql')
    end

end


def main
    ltd = LoadTestData.new
end


if __FILE__ == $0
    main()
end