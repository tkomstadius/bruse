module ApplicationHelper
  def identity_icon(identity)
    case identity.service.downcase
    when 'google_oauth2'
      return fa_icon('google')
    when 'dropbox_oauth2'
      return fa_icon('dropbox')
    else
      return ''
    end
  end
end
