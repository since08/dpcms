$ ->
  class PhotoCropper
    constructor: ->
      that = @
      $('#cropbox').Jcrop
        aspectRatio: 1
        boxHeight: 500
        setSelect: [0, 0, 100, 100]
        onSelect: @update
        onChange: @update,
        -> that.jcropApi = this

    update: (coords) =>
      $('#player_crop_x').val(coords.x)
      $('#player_crop_y').val(coords.y)
      $('#player_crop_w').val(coords.w)
      $('#player_crop_h').val(coords.h)
      @updatePreview(coords)

    updatePreview: (coords) =>
      $('#img_preview').css
        width: Math.round(100/coords.w * $('#cropbox').width()) + 'px'
        height: Math.round(100/coords.h * $('#cropbox').height()) + 'px'
        marginLeft: '-' + Math.round(100/coords.w * coords.x) + 'px'
        marginTop: '-' + Math.round(100/coords.h * coords.y) + 'px'

  $("#player_avatar").change ->
    reader = new FileReader()
    reader.onload = (e) ->
      $('#cropbox').attr('src', e.target.result)
      $('#img_preview').attr('src', e.target.result)
      window.cropper.jcropApi.destroy() if window.cropper
      window.cropper = new PhotoCropper()

    reader.readAsDataURL(this.files[0])





