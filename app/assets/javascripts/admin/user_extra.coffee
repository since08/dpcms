$ ->
  window.SearchUser =
    bindEents: ->
      @bindSuccessCallback();
      @bindSelected();

    bindSuccessCallback: ->
      that = @
      $('.search_user_form').on 'ajax:success', (e, data) ->
        $('.users tbody tr').remove();
        $(that.createUsers(data)).appendTo('.users tbody')
        that.bindSelected()

    bindSelected: ->
      $('.users tbody td:not(.action)').on 'click', (e) ->
        id = $(@).closest("tr").data('id')
        name = $(@).closest("tr").data('name')
        $('#user_extra_user_id').val(id)
        $('#search_user_input input').val(name)
        $(@).closest(".ui-dialog").find('.ui-dialog-titlebar-close').click();

    createUsers: (users) ->
      if users.length == 0
        trs = '<tr><td>没有相关数据</td></tr>'
      else
        trs = ''
      for user in users
        trs += "<tr data-id=#{user.id} data-name=#{user.nick_name}>"
        trs += "<td>#{user.user_uuid}</td>"
        trs += "<td>#{user.nick_name}</td>"
        trs += "<td>#{user.mobile}</td>"
        trs += "<td>#{user.email}</td>"
        trs += '/<tr>'
      trs
