# hylowiki
# GA WDI Project 1
# Author: Michael N. Rubinstein

class User

    attr_reader :id, :password, :fullname, :email
    attr_accessor :username

    def initialize(data)
        @id = data['id']
        @username = data['username']
        @password = data['password']
        @fullname = data['fullname']
        @email = data['email']
    end

    def password_is_correct?(password)
    	return password == @password
    end

end
