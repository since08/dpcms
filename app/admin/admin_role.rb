# rubocop:disable Metrics/BlockLength
ActiveAdmin.register AdminRole do
  config.filters = false
  menu priority: 1, parent: '用户管理'
  permit_params :name, :memo, permissions: []
  form do |f|
    f.inputs do
      f.input :name, label: '角色名称'
      f.input :memo, label: '备注'
      f.input :permissions,
              as: :check_boxes,
              collection: CmsAuthorization.permissions_with_trans
    end
    f.actions
  end

  index do
    id_column
    column(:name)
    column(:memo)
    column(:permissions, &:permissions_text)
    actions
  end

  show do
    attributes_table do
      row(:id)
      row(:name)
      row(:memo)
      row(:permissions, &:permissions_text)
    end
  end

  controller do
    before_action :process_params, only: [:create, :update]
    before_action :destroy_super_admin?, only: [:destroy]

    def process_params
      params[:admin_role][:permissions].reject!(&:empty?)
    end

    def destroy_super_admin?
      return unless resource.name == '超级管理员'

      flash[:error] = '不能删除超级管理员'
      redirect_back fallback_location: admin_admin_roles_url
    end
  end
end
