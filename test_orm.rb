# hylowiki
# GA WDI Project 1
# Author: Michael N. Rubinstein

require 'orm'

def test_orm
    orm = ORM.new

    users = orm.all :users
    page_versions = orm.all :page_versions

    p users
    p page_versions


    user = orm.find :users, 1

    p "User with ID of 1:"
    p user

    user.username = 'bingo_the_cow'

    orm.save_user user

    bingo = orm.find :users, 1

    p "User with ID of 1:"
    p bingo

    p orm.all :users

    p "Seeking Melkur:"
    p orm.find_by :users, :username, 'melkur'


end


if __FILE__ == $0
    test_orm()
end
