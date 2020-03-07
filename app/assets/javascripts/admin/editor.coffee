$ ->
  window.dpEditor =
    isUploadingCheck: false

    call: (textarea, form, options = {}) ->
      editor = @new(textarea, options)
      @imgUploadingCheck(form)
      if options['is_html'] != true
        form.submit(->
          fillValue = toMarkdown(editor.getValue(), { gfm: true })
          editor.textarea.val(fillValue)
        )
      return editor

    imgUploadingCheck: (form) ->
      return if @isUploadingCheck

      @isUploadingCheck = true
      form.submit(->
        if $('.simditor-body img.uploading').length > 0
          alert('文章中的图片未上传成功，请等待上传成功后，再次提交')
          return false
      )

    new: (textarea, options) ->
      toolbar = ['title', 'bold', 'color', 'alignment', 'italic', 'underline', 'strikethrough' ,'hr', '|', 'ol', 'ul', 'blockquote', 'table', 'link','image', 'video', '|', 'dpLink']
      if options['is_html'] != true
        val = textarea.val()
        textarea.val(marked(val))
        toolbar.push('markdown')

      placeholder = if options['placeholder'] then options['placeholder'] else '这里输入文字...'
      new Simditor(
        textarea: textarea,
        toolbar: toolbar,
        toolbarFloat: true,
        placeholder: placeholder,
        pasteImage: true,
        allowedStyles: { span: ['color'] },# 去掉font-size的支持
        upload: {
          url: '/photos',
          fileKey: 'image',
          leaveConfirm: '正在上传文件，如果离开上传会自动取消'
        }
      )
