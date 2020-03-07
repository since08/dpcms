$ ->
  window.SearchTemplate =
    bindEents: ->
      @bindSuccessCallback();
      @bindSelected();

    bindSuccessCallback: ->
      that = @
      $('.search_reply_template_form').on 'ajax:success', (e, data) ->
        $('.reply_templates tbody tr').remove();
        $(that.createReplies(data)).appendTo('.reply_templates tbody')
        that.bindSelected()

    bindSelected: ->
      $('.reply_templates tbody td:not(.action)').on 'click', (e) ->
        name = $(@).closest("tr").data('name')
        $('#search_template_input input[name=memo]').val(name)
        $(@).closest(".ui-dialog").find('.ui-dialog-titlebar-close').click();

    createReplies: (replies) ->
      if replies.length == 0
        trs = '<tr><td>没有相关数据</td></tr>'
      else
        trs = ''
      for reply in replies
        trs += "<tr data-id=#{reply.id} data-name=#{reply.content}>"
        trs += "<td>#{reply.id}</td>"
        trs += "<td>#{reply.content}</td>"
        trs += '/<tr>'
      trs
