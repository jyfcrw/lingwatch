#= require jquery
#= require jquery-ujs
#= require bootstrap
#= require moment
#= require moment/min/locales
#= require bootstrap-switch
#= require eonasdan-bootstrap-datetimepicker

jQuery ->
  $(".form-group.datetimepicker .input-group, .form-group.datepicker .input-group").each ->
    $(this).datetimepicker(format: $(this).data("format"))

  $(".form-group .switch").bootstrapSwitch({
    onText: "是",
    offText: "否"
  })

