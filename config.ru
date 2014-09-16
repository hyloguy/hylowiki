# hylowiki
# GA WDI Project 1
# Author: Michael N. Rubinstein

require 'rack'
require_relative 'hylowiki'


app = HyloWiki::App.new
app = Rack::ShowExceptions.new(app)
app = Rack::Reloader.new(app)
app = Rack::ShowStatus.new(app)
app = Rack::Static.new(app, {
	:urls => ["/public"]
})

Rack::Handler::WEBrick.run app
