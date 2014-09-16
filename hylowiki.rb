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
				autolink: true, hard_wrap: true, quote: true
				)
		end

        def call(env)
            request = Rack::Request.new(env)
            response = handle_request(request)
            return response.finish()
        end

        def handle_request(request)

            Rack::Response.new do |r|
                case request.path_info
                when '/', '/pages/index'
                    page_versions = @orm.all :page_versions
                    r.write render('index', {page_versions: page_versions, markdown: @markdown})
                else
                    r.write "404'd..."
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
