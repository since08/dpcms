class SimditorDpLink extends Simditor.Button
  
  name: 'dpLink'
  
  icon: 'dpLink'
  
  htmlTag: 'dpLink'
  
  disableTag: 'pre'

  appLink: (sourceType, sourceId) ->
    return "approuter://race/#{sourceId}" if sourceType == 'race'

    return "approuter://news/#{sourceId}" if sourceType == 'info'

    return "approuter://video/#{sourceId}" if sourceType == 'video'

  command: ->
    range = @editor.selection.range()
    $contents = $(range.extractContents())
    linkText = @editor.formatter.clearHtml($contents.contents(), false)
    dp_link = $('<a/>', {
      href: '',
      target: '_blank',
      text: linkText || @_t('linkText')
    })

    if @editor.selection.blockNodes().length > 0
      range.insertNode dp_link[0]
    else
      $newBlock = $('<p/>').append(dp_link)
      range.insertNode $newBlock[0]

#    range.selectNodeContents dp_link[0] # 跳出编辑链接
    @editor.selection.range range
    @editor.trigger 'valuechanged'

    dialog = $('.sources_with_select').dialog({ width: '40%' })
    that = @
    dialog.one 'click', 'tbody tr', (e) ->
      id = $(this).data('id')
      type = $(this).data('type')
      dp_link.text($(this).data('title'))
      dp_link.attr('href', that.appLink(type, id));
      dialog.dialog('close')

Simditor.Toolbar.addButton SimditorDpLink