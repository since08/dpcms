# rubocop:disable Metrics/BlockLength
ActiveAdmin.register AdminUser do
  menu priority: 1, parent: '用户管理', label: '管理员列表'
  actions :all, except: [:show]

  permit_params :email, :password, :password_confirmation, admin_role_ids: []
  config.filters = false

  index do
    column 'Id', :id
    column :email
    column :sign_in_count
    column :last_sign_in_at
    column :last_sign_in_ip
    column :created_at
    column :admin_roles do |user|
      user.admin_roles.map(&:name).join(' ')
    end
    actions
  end

  form do |f|
    f.inputs do
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :admin_roles, as: :check_boxes
    end
    f.actions
  end

  controller do
    before_action :process_params, only: [:create, :update]

    def process_params
      return unless params[:admin_user][:password].blank?

      params[:admin_user].delete(:password)
      params[:admin_user].delete(:password_confirmation)
    end
  end
end
