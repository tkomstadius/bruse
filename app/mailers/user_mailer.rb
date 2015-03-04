class UserMailer < ApplicationMailer
  def welcome(user)
    @name = user.name
    mail subject: "Welcome to Bruse.io", to: user.email
  end
end
