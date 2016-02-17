# Use this setup block to configure all options available in SimpleForm.
SimpleForm.setup do |config|
  config.input_class = "form-control"

  config.wrappers :bootstrap, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.use :label

    b.use :input
    b.use :error, wrap_with: { tag: 'span', class: 'help-block' }
    b.use :hint,  wrap_with: { tag: 'span', class: 'help-block' }
  end

  config.wrappers "bootstrap-horizontal", tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder

    b.wrapper :label_wrapper, tag: 'div' do |ba|
      ba.use :label
    end

    b.wrapper :content_wrapper, tag: 'div' do |ba|
      ba.wrapper :input_wrapper, tag: 'div' do |bb|
        bb.use :input
      end

      ba.wrapper :error_wrapper do |bb|
        bb.use :error, wrap_with: { tag: 'span', class: 'help-block' }
      end

      ba.wrapper :hint_wrapper do |bb|
        bb.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
      end
    end
  end

  config.wrappers "bootstrap-input", tag: false do |b|
    b.use :html5
    b.use :placeholder
    b.use :input
  end

  # Wrappers for forms and inputs using the Twitter Bootstrap toolkit.
  # Check the Bootstrap docs (http://twitter.github.com/bootstrap)
  # to learn about the different styles for forms and inputs,
  # buttons and other elements.
  config.default_wrapper = :bootstrap
end

require "simple_form/inputs/datepicker_input.rb"
require "simple_form/inputs/datetimepicker_input.rb"
