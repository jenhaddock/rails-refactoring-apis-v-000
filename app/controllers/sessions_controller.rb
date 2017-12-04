class SessionsController < ApplicationController
  skip_before_action :authenticate_user, only: :create

  def create
    service = GithubService.new
    service.authenticate!(ENV["GITHUB_CLIENT_ID"], ENV["GITHUB_SECRET"], params[:code])
    session[:token] = service.access_token

    session[:username] = service.get_username
    redirect_to '/'
  end
end
