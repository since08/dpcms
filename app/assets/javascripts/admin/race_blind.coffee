$ ->
  if $('.admin_race_blinds').length > 0 && $('.blank_slate').length > 0
    $('.blank_slate').find('a').attr('data-remote', true)

  if ($('#index_table_race_blinds').length > 0)
    $('.blinds tbody').sortable(
      update: (e, ui) ->
        itemId = ui.item.data('id')
        prevId = ui.item.prev().data('id')
        nextId = ui.item.next().data('id')

        $.ajax
          url: "/admin/races/0/race_blinds/#{itemId}/reposition"
          type: "POST"
          data:
            id      : itemId
            prev_id : prevId
            next_id : nextId
    );

  window.SwtichBlindTypeInputs =
    call: ->
      @init_display()
      @bindSwitch()

    init_display: ->
      type = $("#race_blind_blind_type").val()
      @swith_display(type)

    bindSwitch: ->
      that = @
      $("select#race_blind_blind_type").on "change", (e) ->
        that.swith_display(this.value)

    swith_display: (type) ->
      if type == 'blind_content'
        $('.struct_inputs').hide()
        $('.content_inputs').show()
      else
        $('.content_inputs').hide()
        $('.struct_inputs').show()

