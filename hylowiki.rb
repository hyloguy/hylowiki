# hylowiki
# GA WDI Project 1
# Author: Michael N. Rubinstein

# Other people's code:
require 'rack/request'
require 'rack/response'
require 'erubis'
require 'redcarpet'

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
                if request.session['user_id']
                    active_user = @orm.find :users, request.session['user_id']
                else
                    active_user = nil
                end

                case request.path_info
                when '/', '/pages', '/pages/index'
                    page_titles = @orm.current_page_titles
                    users = @orm.all :users
                    r.write render(
                        'pages/index', 
                        {
                            page_titles: page_titles,
                            users: users,
                            active_user: active_user
                        })
                when '/pages/show'
                    page = @orm.find :page_versions, request.GET['id']
                    unless page.nil?
                        page.author = @orm.find :users, page.author_id
                        history = @orm.get_history(page)
                        current = (page.id == history.first.id) ? true : false
                        r.write render(
                            'pages/show',
                            {
                                page: page,
                                history: history,
                                page_titles: @orm.current_page_titles,
                                active_user: active_user, 
                                current: current,
                                markdown: @markdown
                            })
                    else
                        r.write render('404')
                        r.status = 404                        
                    end
                when '/pages/edit'
                    page = @orm.find :page_versions, request.GET['id']
                    r.write render(
                        'pages/edit',
                        {
                            page: page,
                            page_titles: @orm.current_page_titles,
                            active_user: active_user, 
                        })
                when '/pages/delete'
                    if active_user
                        @orm.delete :page_versions, request.GET['id']
                    end
                    r.redirect '/'
                when '/pages/new'
                    if active_user
                        page_titles = @orm.current_page_titles
                        r.write render(
                            'pages/new', 
                            {
                                page_titles: @orm.current_page_titles,
                                active_user: active_user
                            })
                    else
                        r.write render('404')
                        r.status = 404                        
                    end
                when '/pages/create'
                    if request.post? && active_user
                        @orm.store_new :page_versions, {
                            'page_id' => @orm.get_highest_page_id + 1,
                            'author_id' => active_user.id,
                            'time_stamp' => Time.now.to_i,
                            'title' => request.POST['title'],
                            'body' => request.POST['contents']
                        }
                        r.redirect '/'
                    end
                when '/pages/update'
                    if request.post? && active_user
                        @orm.store_new :page_versions, {
                            'page_id' => request.POST['page_id'],
                            'author_id' => active_user.id,
                            'time_stamp' => Time.now.to_i,
                            'title' => request.POST['title'],
                            'body' => request.POST['contents']
                        }
                        r.redirect '/'
                    end
                when '/users/new'
                    users = @orm.all :users
                    r.write render('users/new', {users: users})
                when '/users/create'
                    if request.post?
                        @orm.store_new :users, {
                            'username' => request.POST['username'],
                            'password' => request.POST['password'],
                            'fullname' => request.POST['fullname'],
                            'email' => request.POST['email']
                        }
                        r.redirect '/'
                    end
                when '/login'
                    user = @orm.find_by(:users, :username, request.POST['username']).first
                    if user.nil?
                        r.redirect '/users/new'
                    elsif user.password_is_correct?(request.POST['password'])
                        request.session['user_id'] = user.id
                        r.redirect '/'
                    else
                        r.write 'Incorrect password for that user.'
                    end
                when '/logout'
                    r.delete_cookie 'rack.session'
                    r.redirect '/'
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
