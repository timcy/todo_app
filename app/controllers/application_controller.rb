class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  protected

  def configure_permitted_parameters
    # ADDITIONAL permitted params 
    devise_parameter_sanitizer.for(:sign_up) << [ :user_name, :first_name, :last_name ]
    # devise_parameter_sanitizer.for(:sign_in) << :user_name
    # Overriding Devise default and adding permitted params
    devise_parameter_sanitizer.for(:account_update){
      |u| u.permit( :email, :user_name, :first_name, :last_name, :password, :password_confirmation, :current_password, roles: [] )
    }
  end

end
