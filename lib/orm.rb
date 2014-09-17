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

    # CONSTRUCTOR
    def initialize
        delete_database_if_it_exists    # REMOVE*
        connect_to_database             
        configure_database
        load_schema                     # REMOVE*
        load_data                       # REMOVE*
    end

    # GENERIC METHODS FOR ALL MODELS
    def all(table)
        results = @db.execute <<-SQL
            SELECT *
            FROM #{table}
        SQL

        results.map do |row|
            model = TABLE_CLASS_MAP[table]
            model.new(row)
        end
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

    # SPECIFIC METHODS FOR PAGE_VERSION MODEL
    def current_page_titles
        arr = all_page_titles
        arr
            .uniq{|p| p.page_id}
            .map { |p1| arr.select {|p2| p2.page_id == p1.page_id} }
            .map { |a| a.max_by {|p| p.time_stamp} }
    end

    def all_page_titles
        results = @db.execute <<-SQL
            SELECT id, page_id, time_stamp, title
            FROM page_versions
        SQL

        results.map {|row| PageVersion.new(row) }
    end

    def get_history(page)
        find_by(:page_versions, :page_id, page.page_id)
            .map {|page| 
                page.author = find(:users, page.author_id)
                page 
            }
            .sort_by {|page| page.time_stamp}
            .reverse
    end

    # def store_new_page_version(page)
    #     prev_versions 
    # end

    # SPECIFIC METHODS FOR USER MODEL
    def save_user(user)
        @db.execute <<-SQL, [user.username, user.id]
            UPDATE users SET
                username = ?
            WHERE
                id = ?
        SQL
    end

    # HELPER METHODS
    private

    def connect_to_database
        @db = SQLite3::Database.new(DB_FILE)
    end

    def configure_database
        @db.execute 'PRAGMA foreign_keys = true;'
        @db.results_as_hash = true
    end

    # REMOVE THESE METHODS AFTER CREATE PAGE/USER ARE IMPLEMENTED
    def delete_database_if_it_exists
        if File.exist? DB_FILE
            File.delete DB_FILE
        end
    end

    def load_schema
        @db.execute_batch File.read('scripts/schema.sql')
    end

    def load_data
        @db.execute_batch File.read('scripts/data.sql')
    end

end
