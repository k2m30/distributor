class ApplicationController < ActionController::Base
  before_filter :configure_permitted_parameters, if: :devise_controller?

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def get_price (item, site)
    common_url = item.urls & site.urls
    if !(common_url).empty?
      return common_url.first.price
    else
      return nil
    end
  end

  def get_url (item, site)
    return (item.urls & site.urls).first
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit :username, :email, :password, :password_confirmation
    end
  end
end
