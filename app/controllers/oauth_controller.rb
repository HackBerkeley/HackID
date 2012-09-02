class OauthController < ApplicationController
  before_filter :authenticate_user!, :except => :access_token
  protect_from_forgery :except => :access_token

  def dialog
    @state = params[:state]
    @client = Client.find(params[:client_id])
    @redirect_uri = params[:redirect_uri]
    if access_code = AccessCode.where(:client_id => @client._id, :user_id => current_user._id).first
      redirect_to "#{@redirect_uri}?state=#{@state}&code=#{access_code.value}"
    end
  end

  def authorize
    allow_access = params[:allow_access]
    state = params[:state]
    client = Client.find(params[:client_id])
    redirect_uri = URI.decode(params[:redirect_uri])
    if allow_access
      code = client.allow_access_to_user(current_user)
      successful = client.save
    else
      redirect_to "#{redirect_uri}?error_reason=user_denied&error=access_denied&error_description=The+user+denied+your+request&state=#{state}"
    end
    if successful
      redirect_to "#{redirect_uri}?state=#{state}&code=#{code}"
    else
      redirect_to "#{redirect_uri}?error_reason=access_code_error&error=internal_server_error&error_description=There+was+an+error+creating+your+access+code&state=#{state}"
    end
  end

  def access_token
    code = params[:code]
    client_secret = params[:client_secret]
    client = Client.where(:_id => params[:client_id], :client_secret => client_secret).first
    if client
      access_code = AccessCode.where(:client_id => client._id, :value => code).first
      access_token, expiration = access_code.generate_token!
      render :text => "access_token=#{access_token}&expires=#{(expiration - Time.now).to_i}"
    else
      render :json => {"Unauthorized" => "You do not have the appropriate credentials."}.to_json, :status => 403
    end
  end
end
