module BootstrapTags
  def bootstrap_horizontal_form_for(*args, &block)
    options = {
      wrapper: 'bootstrap-horizontal',
      html: { class: "form-horizontal" },
      builder: BootstrapHorizontalBuilder
    }.deep_merge(args.extract_options!)

    options[:defaults] = bootstrap_horizontal_defaults.deep_merge(options[:defaults] || {})

    simple_form_for(*args, options, &block)
  end

  def bootstrap_horizontal_defaults
    {
      label_wrapper_html: { class: "col-sm-2" },
      input_wrapper_html: { class: "col-sm-6" },
      hint_wrapper_html:  { class: "col-sm-4" },
      error_wrapper_html: { class: "col-sm-4" }
    }
  end

  class BootstrapHorizontalBuilder < SimpleForm::FormBuilder
    def content_wrapper(options = {}, &block)
      input :to_s, options.merge(label: false, error_wrapper: false), &block
    end
  end
end