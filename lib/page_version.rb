# hylowiki
# GA WDI Project 1
# Author: Michael N. Rubinstein

class PageVersion

    attr_reader :id, :page_id, :author_id, :time_stamp, :title, :body

    def initialize(data)
        @id = data['id']
        @page_id = data['page_id']
        @author_id = data['author_id']
        @time_stamp = data['time_stamp']
        @title = data['title']
        @body = data['body']
    end

end
