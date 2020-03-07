$ ->
  check_path = window.location.pathname.indexOf('video_groups')
  if ($('#index_table_videos').length > 0 && check_path > 0)
    $('#index_table_videos tbody').sortable(
      update: (e, ui) ->
        console.log(ui.item)
        itemId = ui.item.attr('id')
        prevId = ui.item.prev().attr('id')
        nextId = ui.item.next().attr('id')

        $.ajax
          url: "/admin/videos/#{itemId.split('_').pop()}/reposition"
          type: "POST"
          data:
            id      : itemId
            prev_id : prevId
            next_id : nextId
    );


