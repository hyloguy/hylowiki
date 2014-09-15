def main
    orm = ORM.new

    users = orm.all :users
    posts = orm.all :posts

    p users
    p posts
end


if __FILE__ == $0
    main()
end
