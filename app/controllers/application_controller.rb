require "simple_captcha"

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SimpleCaptcha::ControllerHelpers

protected
  def ok_url_or_default(default)
    params[:ok_url] || default
  end

  def ok_url_or(default)
    params[:ok_url] || default
  end

  def privilege_ajax?
    (request.headers['X-Privilege'] || "").downcase == "allow"
  end

  def h(model_class, attribute = nil)
    if attribute
      model_class.human_attribute_name(attribute)
    else
      model_class.model_name.human
    end
  end
  helper_method :h

  def i18n(*args)
    result = translate(*args)
    options = args.extract_options!
    attributes = Hashie::Mash.new(options)
    result.gsub(/(?:#\{)(.*)(?:\})/) { attributes.instance_eval($1) }
  end
  helper_method :i18n
end
