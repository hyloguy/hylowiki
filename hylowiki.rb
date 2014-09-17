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
                active_user = nil
                active_user = @orm.find :users, 1

                case request.path_info
                when '/', '/pages', '/pages/index'
                    page_titles = @orm.current_page_titles
                    r.write render(
                        'pages/index', 
                        {page_titles: page_titles, active_user: active_user})
                when '/pages/show'
                    page = @orm.find :page_versions, request.GET['id']
                    page.author = @orm.find :users, page.author_id
                    history = @orm.get_history(page)
                    current = (page.id == history.first.id) ? true : false
                    r.write render(
                        'pages/show',
                        {
                            page: page,
                            history: history,
                            active_user: active_user, 
                            current: current,
                            markdown: @markdown
                        })
                when '/pages/new'
                    if active_user
                        page_titles = @orm.current_page_titles
                        r.write render(
                            'pages/new', 
                            {page_titles: page_titles, active_user: active_user})
                    else
                        r.write render('404')
                        r.status = 404                        
                    end
                when '/pages/create'
                    if request.post? && active_user
                        new_page = PageVersion.new({
                            'page_id' => @orm.get_highest_page_id + 1,
                            'author_id' => active_user.id,
                            'time_stamp' => Time.now.to_i,
                            'title' => request.POST['title'],
                            'body' => request.POST['contents']
                            })
                        @orm.store_new_page(new_page)
                        r.redirect '/'
                    end
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
