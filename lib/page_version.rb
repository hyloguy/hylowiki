# hylowiki
# GA WDI Project 1
# Author: Michael N. Rubinstein

class PageVersion

    attr_reader :id, :page_id, :author_id, :time_stamp, :title, :body
    attr_accessor :author

    def initialize(data)
        @id = data['id']
        @page_id = data['page_id']
        @author_id = data['author_id']
        @time_stamp = data['time_stamp']
        @title = data['title']
        @body = data['body']
        @author = nil
    end

    def id_of(title, page_titles)
        matching_page = page_titles.find {|p| p.title.downcase == title.downcase }
        return 0 if matching_page.nil?
        return matching_page.id
    end

    def processed_body(page_titles)
        @body.gsub(/\[\[(\w+)\]\]/)  do |t|
            "[#{$1}](/pages/show?id=#{id_of($1, page_titles)})"
        end
    end

end
