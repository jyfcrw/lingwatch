module SimpleForm
  module Inputs
    class DatepickerInput < Base

      def input
        value = object.send(attribute_name)
        input_html_options[:value] ||= localized(value, input_group_options[:"data-format"])

        @builder.template.content_tag("div", input_group_options) do
          @builder.text_field(attribute_name, input_html_options) +
          '<span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span>'.html_safe
        end
      end

    protected
      def input_group_options
        options = {}
        options[:class] = "input-group date"
        options[:"data-format"] = input_html_options[:"data-format"] || "YYYY-MM-DD"
        options[:"data-language"] = I18n.locale.to_s.downcase
        options[:"data-picktime"] = false
        options
      end

      def localized(time, format)
        time.try(:strftime, convert_to_ruby_format(format))
      end

      def convert_to_ruby_format(picker_format)
        format = picker_format.dup
        format.gsub!("YYYY", "%Y")
        format.gsub!("YY", "%y")
        format.gsub!("MM", "%m")
        format.gsub!("DD", "%d")

        format.gsub!("HH", "%H")
        format.gsub!("hh", "%h")
        format.gsub!("mm", "%M")
        format.gsub!("ss", "%S")
      end
    end
  end
end