class ApplicationController < ActionController::Base
  protect_from_forgery

  def after_sign_in_path_for(resource)
    sign_in_url = url_for(:action => 'new', :controller => 'devise/sessions', :only_path => false)
    sign_up_url = url_for(:action => 'new', :controller => 'registrations', :only_path => false)
    if (request.referer == sign_in_url) || (request.referer == sign_up_url)
      super
    else
      request.referer || stored_location_for(resource) || root_path
    end
  end
end
