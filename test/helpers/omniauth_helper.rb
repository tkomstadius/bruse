OmniAuth.config.test_mode = true
omniauth_hash_new = { 'provider' => 'dropbox_oauth2',
                      'info' => {
                          'name' => 'Kalle Bar',
                          'email' => 'kalle@bar.com',
                          'uid' => '666666'
                      },
                      'credentials' => {
                        'token' => '1234xyz666abc'
                      }
}

omniauth_hash_old = { 'provider' => 'dropbox_oauth2',
                      'info' => {
                          'name' => 'Foo Bar',
                          'email' => 'foo@bar.com',
                          'uid' => '666123'
                      },
                      'credentials' => {
                        'token' => 'xyz123'
                      }
}

OmniAuth.config.add_mock(:dropbox_new, omniauth_hash_new)
OmniAuth.config.add_mock(:dropbox_old, omniauth_hash_old)

def log_in_user(user_id)
  session[:user] = user_id
end

def log_out_user(user_id)
  if session[:user] == user_id
    session[:user] = nil
  end
end
