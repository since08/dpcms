$ ->
  if $('.admin_test_users').length > 0 && $('.blank_slate').length > 0
    $('.blank_slate').find('a').attr('data-remote', true)

  window.SearchUsers =
    bindEents: ->
      @bindSuccessCallback();

    bindSuccessCallback: ->
      that = @
      $('.search_users_form').on 'ajax:success', (e, data) ->
        $('.users tbody tr').remove();
        $(that.createUsers(data)).appendTo('.users tbody')

    createUsers: (users) ->
      if users.length == 0
        trs = '<tr><td>没有相关数据</td></tr>'
      else
        trs = ''
      for user in users
        trs += "<tr data-id=#{user.id} data-name=#{user.name}>"
        trs += "<td>#{user.id}</td>"
        trs += "<td>#{user.nick_name}</td>"
        trs += "<td>#{user.mobile}</td>"
        trs += "<td class='action'><a href='/admin/test_users/#{user.id}/build' data-remote='true' data-method='post'>添加</a></td>"
        trs += '/<tr>'
      trs
