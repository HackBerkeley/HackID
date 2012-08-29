class ApplicationController < ActionController::Base
  protect_from_forgery

  def after_sign_in_path_for(resource)
    sign_up_url = new_user_registration_url
    sign_in_url = new_user_session_url
    if (request.referer == sign_in_url) || (request.referer == sign_up_url)
      super
    else
      request.referer || stored_location_for(resource) || root_path
    end
  end
end
