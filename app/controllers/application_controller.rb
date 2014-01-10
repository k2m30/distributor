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

  def set_price (item, site, price)
    url = (item.urls & site.urls).first || Url.new
    url.site = site
    url.item = item
    url.price = price
    url.url = '#' if url.url.nil?
    url.save
  end

  def get_url (item, site)
    return (item.urls & site.urls).first
  end

  def spaces(x)
    str = x.to_i.to_s.reverse
    str.gsub!(/([0-9]{3})/,"\\1 ")
    return str.gsub(/,$/, '').reverse
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit :username, :email, :password, :password_confirmation
    end
  end

  def after_sign_in_path_for(resource)
    stop_list_sites_path
  end

end
