class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Lockup application for staging environment only
  skip_before_action :check_for_lockup unless Rails.env.staging?

  def after_sign_in_path_for(resource)
    onsgeheim_root_path
  end
end
