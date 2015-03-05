Rails.application.config.middleware.use OmniAuth::Builder do
  provider :dropbox_oauth2, ENV['DROPBOX_KEY'], ENV['DROPBOX_SECRET']

  OmniAuth.config.on_failure = Proc.new do |env|
  	# will invoke the omniauth_failure action in PagesController
  	PagesController.action(:omniauth_failure).call(env)
  end
end
