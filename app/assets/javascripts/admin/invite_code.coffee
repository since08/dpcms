$ ->
  if $("#invite_code_coupon_type").val() == 'no_discount'
    $("#invite_code_coupon_number").attr('disabled', true)

  $("#invite_code_coupon_type").change ->
    if $(this).val() == 'no_discount'
      $("#invite_code_coupon_number").val(0)
      $("#invite_code_coupon_number").attr('disabled', true)
    else
      $("#invite_code_coupon_number").attr('disabled', false)
