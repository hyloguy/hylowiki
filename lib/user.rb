# hylowiki
# GA WDI Project 1
# Author: Michael N. Rubinstein

class User

    attr_reader :id, :username, :password, :fullname, :email

    def initialize(data)
        @id = data['id']
        @username = data['username']
        @password = data['password']
        @fullname = data['fullname']
        @email = data['email']
    end

end
