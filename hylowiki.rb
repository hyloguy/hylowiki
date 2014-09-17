# hylowiki
# GA WDI Project 1
# Author: Michael N. Rubinstein

# Other people's code:
require 'rack/request'
require 'rack/response'
require 'erubis'
require 'redcarpet'
require 'ap'
require 'pry'

# MY code:
require 'orm'


module HyloWiki

	class App

		def initialize()
			@orm = ORM.new
			@markdown = Redcarpet::Markdown.new(
				Redcarpet::Render::HTML,
				autolink: true, hard_wrap: true, quote: true)
		end

        def call(env)
            request = Rack::Request.new(env)
            response = handle_request(request)
            return response.finish()
        end

        def handle_request(request)

            Rack::Response.new do |r|
                logged_in = true
                case request.path_info
                when '/', '/pages', '/pages/index'
                    page_titles = @orm.current_page_titles
                    r.write render(
                        'index', 
                        {page_titles: page_titles, logged_in: logged_in})
                when '/pages/show'
                    page = @orm.find :page_versions, request.GET["id"]
                    user = @orm.find :users, page.author_id
                    history = @orm
                        .find_by(:page_versions, :page_id, page.page_id)
                        .map {|page| 
                            page.author = @orm.find(:users, page.author_id)
                            page 
                        }
                        .sort_by {|page| page.time_stamp}
                        .reverse
                    current = (page.id == history.first.id) ? true : false
                    r.write render(
                        "show",
                        {
                            page: page,
                            user: user, 
                            history: history,
                            logged_in: logged_in, 
                            current: current,
                            markdown: @markdown
                        })
                else
                    r.write render('404')
                    r.status = 404
                end
            end
        end

        def render(name, locals={})
            path = "views/"+name+".erb"
            file = File.read(path)
            Erubis::Eruby.new(file).result(locals)
        end
    end
end
