class PageVersion

    attr_reader :id, :page_id, :title, :body

    def initialize(data)
        @id = data['id']
        @page_id = data['page_id']
        @title = data['title']
        @body = data['body']
    end

end
