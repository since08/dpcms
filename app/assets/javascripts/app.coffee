$ ->
  window.FormDialog =
    dialogClass: 'cms_form_dialog'
    overlayId: 'form_dialog_overlay'

    addOverlayDiv: ->
      $("<div class='ui-widget-overlay ui-front' id='#{@overlayId}'></div>").appendTo('body')

    wrapWithDialog: (form) ->
      $("<div class=#{@dialogClass}>#{form}</div>")

    popup: (form) ->
      @wrapWithDialog(form).appendTo('body')
      @addOverlayDiv()
      @bind_close()
      return

    replaceForm: (form) ->
      $(".#{@dialogClass}").find('form').replaceWith(form);
      @bind_close()
      return

    bind_close: ->
      dialog = $(".#{@dialogClass}")
      overlay = $("##{@overlayId}")
      $('.cancel_form_dialog').click (e) ->
        e.preventDefault()
        dialog.remove()
        overlay.remove()