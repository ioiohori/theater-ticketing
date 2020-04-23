class ApplicationController < ActionController::Base

  include Pundit

  protect_from_forgery with: :exception

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :set_paper_trail_whodunnit

  def authenticate_admin_user!
    raise Pundit::NotAuthorizedError unless current_user&.admin?
  end

  # def authenticate_admin!
  #   redirect_to new_user_session_path unless current_user&.admin?
  # end

  def current_user
    return nil if session[:awaiting_authy_user_id].present?
    super
  end

  def current_cart
    ShoppingCart.for(user: current_user)
  end

  def user_for_paper_trail
    simulating_admin_user || current_user
  end

  def simulating_admin_user
    User.find_by(id: session[:admin_id])
  end

  helper_method :simulating_admin_user

  private

  def user_not_authorized
    sign_out(User)
    render plain: "Access Not Allowed", status: :forbidden
  end
end
