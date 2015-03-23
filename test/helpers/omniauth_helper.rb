require "test_helper"
OmniAuth.config.test_mode = true

def dropbox_new
  omniauth_hash_new = { 'provider' => 'dropbox_oauth2',
                        'uid' => '666666',
                        'info' => {
                            'name' => 'Kalle Bar',
                            'email' => 'kalle@bar.com'
                        },
                        'credentials' => {
                          'token' => '1234xyz666abc'
                        }
  }
  OmniAuth.config.add_mock(:dropbox_oauth2, omniauth_hash_new)
end

def dropbox_old
  omniauth_hash_old = { 'provider' => 'dropbox_oauth2',
                        'uid' => '666123',
                        'info' => {
                            'name' => users(:fooBar).name,
                            'email' => users(:fooBar).email
                        },
                        'credentials' => {
                          'token' => 'xyz123'
                        }
  }
  OmniAuth.config.add_mock(:dropbox_oauth2, omniauth_hash_old)
end
