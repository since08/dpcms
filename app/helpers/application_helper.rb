module ApplicationHelper
  # 定制标题的公共方法
  def full_title(page_title = '')
    base_title = 'DeshPro CMS'
    if page_title.empty?
      base_title
    else
      page_title + ' · ' + base_title
    end
  end

  def avatar(src, options = {})
    html_options = { class: 'img-circle', size: 60 }.merge(options)
    image_tag(src || 'default_avatar.jpg', html_options)
  end

  def markdown(content)
    renderer = Redcarpet::Render::HTML.new(hard_wrap: true, filter_html: true)
    options = {
      autolink: false,
      no_intra_emphasis: true,
      disable_indented_code_blocks: true,
      fenced_code_blocks: true,
      lax_html_blocks: true,
      strikethrough: true,
      superscript: true
    }
    Redcarpet::Markdown.new(renderer, options).render(content)
  end

  def multilingual_editor_switch
    content = radio_button_tag(:common_lang, 'cn', true) <<
              content_tag(:span, ' 中文 &nbsp&nbsp&nbsp'.html_safe) << # rubocop:disable Rails/OutputSafety
              radio_button_tag(:common_lang, 'en') <<
              content_tag(:span, ' 英文')
    content_tag(:li, content, class: 'common_radio_lang')
  end

  def editable_text_column(resource, attr)
    val = resource.send(attr)
    val = '' if val.blank?
    out = []
    out << content_tag(:div, val, id: "editable_text_column_#{attr}_#{resource.id}",
                                  class: 'editable_text_column',
                                  ondblclick: 'quickEditable.editable_text_column_do(this)')
    out << content_tag(:input, nil, class: 'editable_text_column admin-editable',
                                    id: "editable_text_column_#{attr}_#{resource.id}",
                                    style: 'display:none;',
                                    data: { path: resource_path(resource),
                                            'resource-class': resource.class.name.downcase,
                                            attr: attr })
    safe_join(out)
  end
end
