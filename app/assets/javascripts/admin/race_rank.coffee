$ ->
  if $('.admin_race_ranks').length > 0 && $('.blank_slate').length > 0
    $('.blank_slate').find('a').attr('data-remote', true)

  window.SearchPlayer =
    bindEents: ->
      @bindSuccessCallback();
      @bindSelected();

    bindSuccessCallback: ->
      that = @
      $('.search_player_form').on 'ajax:success', (e, data) ->
        $('.players tbody tr').remove();
        $(that.createPlayers(data)).appendTo('.players tbody')
        that.bindSelected()

    bindSelected: ->
      $('.players tbody td:not(.action)').on 'click', (e) ->
        id = $(@).closest("tr").data('id')
        name = $(@).closest("tr").data('name')
        $('#race_rank_player_id').val(id)
        $('#search_player_input input').val(name)
        $(@).closest(".ui-dialog").find('.ui-dialog-titlebar-close').click();

    createPlayers: (players) ->
      if players.length == 0
        trs = '<tr><td>没有相关数据</td></tr>'
      else
        trs = ''
      for player in players
        trs += "<tr data-id=#{player.id} data-name=#{player.name}>"
        trs += "<td>#{player.player_id}</td>"
        trs += "<td>#{player.name}</td>"
        trs += "<td>#{player.country}</td>"
        trs += "<td class='action'><a href='/admin/players/#{player.id}/edit' data-remote='true'>编辑</a></td>"
        trs += '/<tr>'
      trs
