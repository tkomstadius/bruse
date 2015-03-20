Rails.application.config.middleware.use OmniAuth::Builder do
  #provider :dropbox_oauth2, ENV['DROPBOX_KEY'], ENV['DROPBOX_SECRET']
  provider :google_oauth2, ENV['DRIVE_KEY'], ENV['DRIVE_SECRET'],
  {  :scope => 'email,profile'}

  OmniAuth.config.on_failure = Proc.new do |env|
    # will invoke the omniauth_failure action in PagesController
    redirect_to omniauth_failure_url(env)
  end
end
