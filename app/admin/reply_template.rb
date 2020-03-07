# rubocop:disable Metrics/BlockLength
ActiveAdmin.register ReplyTemplate do
  permit_params :type_id, :content
  menu priority: 22, parent: '模版管理'

  filter :type_id, as: :select, collection: TemplateType.all
  filter :content
  filter :created_at

  index do
    column :id
    column :type_name do |reply|
      reply.template_type&.name
    end
    column :content
    column :created_at
    actions
  end

  form partial: 'form'

  controller do
    def new
      @reply_template = ReplyTemplate.new
      @reply_template.type_id = params[:type_id] unless params[:type_id].blank?
    end

    def create
      @reply_template = ReplyTemplate.new(reply_template_params)
      respond_to do |format|
        if @reply_template.save
          format.html { redirect_to admin_reply_templates_url }
        else
          format.html { render :new }
        end
        format.js
      end
    end

    private

    def reply_template_params
      params.require(:reply_template).permit(:type_id, :content)
    end
  end

  member_action :reply_template_table, method: :get do
    render 'reply_table'
  end
end
