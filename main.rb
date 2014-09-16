# hylowiki
# GA WDI Project 1
# Author: Michael N. Rubinstein

require 'orm'

def main
    orm = ORM.new

    users = orm.all :users
    page_versions = orm.all :page_versions

    p users
    p page_versions
end


if __FILE__ == $0
    main()
end
