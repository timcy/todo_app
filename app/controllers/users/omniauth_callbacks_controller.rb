class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  
  def facebook
    provider_callback('facebook')
  end

  def twitter
    provider_callback('twitter')
  end

  def linkedin
    provider_callback('linkedin')
  end
  
  protected

  def provider_callback(provider)
    @user ||= User.from_omniauth(request.env["omniauth.auth"])
    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => provider) if is_navigational_format?
    else
      session["devise.#{provider}_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end     
  end

end