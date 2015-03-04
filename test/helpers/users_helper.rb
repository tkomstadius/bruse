require 'test_helper'

def log_in_user(user_id)
  session[:user] = user_id
end

def log_out_user(user_id)
  if session[:user] == user_id
    session[:user] = nil
  end
end
