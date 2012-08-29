class RegistrationsController < Devise::RegistrationsController
  def new
    resource = build_resource({})
    respond_to do |f|
      f.html do
        render "devise/sessions/new"
      end
    end
  end
end
