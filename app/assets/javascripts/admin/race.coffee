$ ->
  $("select.ajax_change_status").on("change", (e) ->
    this_select = $(this)
    before_val = this_select.data('before-val')
    after_val  = this_select.val()
    $.ajax
      url: this_select.data('url')
      type: "PUT"
      data:
        status : after_val
      success: (res) ->
        alert('修改成功')
        this_select.data('before-val', after_val)
#        this_select.find("option[value='#{after_val}']").attr("selected", true);
      error: (res) ->
        alert('修改失败')
        this_select.find("option").removeAttr("selected")
        this_select.find("option[value='#{before_val}']").attr("selected", true);
  );

  $(':checkbox#race_describable').click (e) ->
    unless $(this).is(':checked')
      $(':checkbox#race_ticket_sellable')[0].checked = false
      return

  if $('.ticket_number_manage').length > 0
    class ShakeTicketing
      constructor: ->
        @ticket_info_id = $('#ticket_info_id').val();
        @race_id = $('#race_id').val();
        @shake_font_size = '25px'
        @original_font_size = '16px'
        @start()

      start: ->
        shake_ticketing = @
        $.ajax
          url: "/admin/ticket_infos/#{@ticket_info_id}.json"
          type: "get"
          success: (res) ->
            shake_ticketing.shake_entity_ticket(res)
            shake_ticketing.shake_e_ticket(res)
            shake_ticketing.refresh_ticket(res)

      refresh_ticket: (data) ->
        surplus_ticket_text = "剩余#{data.surplus_e_ticket}张电子票，#{data.surplus_entity_ticket}张实体票"
        $('#surplus_ticket').text(surplus_ticket_text)

      shake_e_ticket: (data) ->
        ori_surplus_e_ticket = $('#e_ticket_text').data('surplus-e-ticket')
        unless ori_surplus_e_ticket == data.surplus_e_ticket
          e_ticket_text = "共#{data.e_ticket_number}张，已售#{data.e_ticket_sold_number}张，剩余#{data.surplus_e_ticket}"
          $('#e_ticket_text').text(e_ticket_text)
            .animate({fontSize: @shake_font_size},"fast")
            .animate({fontSize: @original_font_size},"fast")
          $('#e_ticket_text').data('surplus-e-ticket', data.surplus_e_ticket)

      shake_entity_ticket: (data) ->
        ori_surplus_entity_ticket = $('#entity_ticket_text').data('surplus-entity-ticket')
        unless ori_surplus_entity_ticket == data.surplus_entity_ticket
          entity_ticket_text = "共#{data.entity_ticket_number}张，已售#{data.entity_ticket_sold_number}张，剩余#{data.surplus_entity_ticket}"
          $('#entity_ticket_text').text(entity_ticket_text)
            .animate({fontSize: @shake_font_size},"fast")
            .animate({fontSize: @original_font_size},"fast")
          $('#entity_ticket_text').data('surplus-entity-ticket', data.surplus_entity_ticket)

    new_shake_ticketing = -> new ShakeTicketing()
    setInterval(new_shake_ticketing, 2000)