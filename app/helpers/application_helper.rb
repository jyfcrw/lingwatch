module ApplicationHelper
  include BootstrapTags

  def show_link(*args, &block)
    options = args.extract_options!
    args.unshift(%Q[<i class="fa fa-eye"></i> #{t('links.show', scope: :view)}].html_safe) if block.nil?
    link_to(*args, options, &block)
  end

  def edit_link(*args, &block)
    options = args.extract_options!
    args.unshift(%Q[<i class="fa fa-pencil"></i> #{t('links.edit', scope: :view)}].html_safe) if block.nil?
    link_to(*args, options, &block)
  end

  def delete_link(*args, &block)
    options = args.extract_options!
    options[:method] ||= "delete"
    options[:data] ||= {}
    options[:data][:confirm] ||= t('links.delete_confirm', scope: :view)
    args.unshift(%Q[<i class="fa fa-times"></i> #{t('links.delete', scope: :view)}].html_safe) if block.nil?
    link_to(*args, options, &block)
  end

  def ok_url_tag
    hidden_field_tag "ok_url", params[:ok_url] if !params[:ok_url].blank?
  end

  def widget_window_form_for(*args, &block)
    options = args.extract_options!
    options[:defaults] = {
      label_wrapper_html: { class: "col-sm-2" },
      input_wrapper_html: { class: "col-sm-5" },
      hint_wrapper_html:  { class: "col-sm-offset-2 col-sm-10" },
      error_wrapper_html: { class: "col-sm-5" }
    }.merge(options[:defaults] || {})

    bootstrap_horizontal_form_for(*args, options, &block)
  end

  def title(value)
    content_for :title, value
    value
  end

  def public_subdomain_url(source, subdomain = nil)
    if source.include?("://")
      source
    else
      if subdomain
        host = "#{subdomain}.#{request.domain}:#{request.port.to_s}"
      else
        host = request.host_with_port
      end
      "#{request.protocol}#{host}#{public_path(source)}"
    end
  end
end
