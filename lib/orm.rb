# hylowiki
# GA WDI Project 1
# Author: Michael N. Rubinstein

require 'sqlite3'
require 'user'
require 'page_version'

class ORM

    TABLE_CLASS_MAP = {
        :users => User,
        :page_versions => PageVersion
    }

    DB_FILE = 'hylowiki.db'

    def initialize
        delete_database_if_it_exists
        connect_to_database
        configure_database
        load_schema
        load_data
    end

    def all(table)
        results = @db.execute("SELECT * FROM #{table}")

        results.map do |row|
            model = TABLE_CLASS_MAP[table]
            model.new(row)
        end
    end

    def save_user(user)
        @db.execute <<-SQL, [user.username, user.id]
            UPDATE users SET
                username = ?
            WHERE
                id = ?
        SQL
    end

    def find(table, id)
        row = @db.get_first_row <<-SQL, [id]
            SELECT *
            FROM #{table}
            WHERE id = ?
        SQL

        model = TABLE_CLASS_MAP[table]
        model.new(row)
    end

    def find_by(table, column, value)
        results = @db.execute <<-SQL, value
            SELECT *
            FROM #{table}
            WHERE #{column} = ?
        SQL

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
        @db.execute_batch File.read('scripts/schema.sql')
    end

    def load_data
        @db.execute_batch File.read('scripts/data.sql')
    end

end
