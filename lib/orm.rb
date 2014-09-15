class ORM

    TABLE_CLASS_MAP = {
        :users => User,
        :posts => Post
    }

    DB_FILE = 'banter.db'

    def initialize
        delete_database_if_it_exists
        connect_to_database
        configure_database
        load_schema
        load_data
    end

    def all(table)
        results = @db.execute("select * from #{table}")

        results.map do |row|
            model = TABLE_CLASS_MAP[table]
            model.new(row)
        end
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
        @db.execute_batch File.read('schema.sql')
    end

    def load_data
        @db.execute_batch File.read('data.sql')
    end

end
