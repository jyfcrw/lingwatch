require_relative "datepicker_input"

module SimpleForm
  module Inputs
    class DatetimepickerInput < DatepickerInput

    protected
      def input_group_options
        options = {}
        options[:class] = "input-group date"
        options[:"data-format"] = input_html_options[:"data-format"] || "YYYY-MM-DD HH:mm"
        options[:"data-language"] = I18n.locale.to_s.downcase
        options[:"data-picktime"] = true
        options[:"data-useseconds"] = true if options[:"data-format"].include?("ss")
        options[:"data-pick12hourformat"] = false
        options
      end
    end
  end
end