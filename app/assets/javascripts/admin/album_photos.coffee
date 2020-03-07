$ ->
  window.albumPhotos =
    click_img_to_cropbox: (source, cropbox, options) ->
      source.on('click', 'img', ->
        DpCropper.toCropbox(cropbox, this.src, options)
        $('#remote_img_url').val(this.src);
        $(this).parents(".ui-dialog").remove();
      )

    bind_changed_get_photos: (source) ->
      source.change ->
        album_id = if $(this).val() then $(this).val() else 0
        $.ajax(url: "/shop/albums/#{album_id}/photos")


