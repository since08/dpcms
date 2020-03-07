$ ->
  $('.common_radio_lang input[type=radio]').click ->
    checked_value = $(".common_radio_lang input[name=common_lang]:checked").val()
    if checked_value == 'cn'
      $('#markdown_en').hide()
      $('#markdown_cn').show()
    else
      $('#markdown_cn').hide()
      $('#markdown_en').show()