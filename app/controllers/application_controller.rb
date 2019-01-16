class ApplicationController < ActionController::API
  before_action :authorize_by_token

  private

  def authorize_by_token
    @current_user = User.where(token: params[:token]).first

    render json: {error: 'unauthorized'}, status: :unauthorized unless @current_user
  end
end
