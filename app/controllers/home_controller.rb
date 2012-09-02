class HomeController < ApplicationController
  def index
  end

  def dev_api
    @example = <<-EOF
require "rubygems"
require "sinatra"
require "sinatra/contrib/all"
require "json"
require "httparty"

def client_id
  ENV["CLIENT_ID"]
end

def client_secret
  ENV["CLIENT_SECRET"]
end

enable :sessions

get "/login" do
  redirect "https://hackid.herokuapp.com/dialog/oauth?client_id=" + \\
            "\#{client_id}&redirect_uri=\#{URI.escape("http://localhost:5453/oauth_return")}"
end

get "/oauth_return" do
  b = HTTParty.post("http://hackid.herokuapp.com/oauth/access_token", { :query => {
    "code" => params[:code],
    "client_secret" => client_secret,
    "client_id" => client_id
  }}).body
  a = Rack::Utils.parse_nested_query(b)["access_token"]
  "Hello, \#{JSON.parse(HTTParty.get("http://hackid.herokuapp.com/me?access_token=\#{a}").body)["name"]}"
end
EOF
  end
end
