class CreateAdminUsersRoles < ActiveRecord::Migration[5.0]
  def change
    create_table :admin_users_roles do |t|
      t.belongs_to :admin_user, index: true
      t.belongs_to :admin_role, index: true
    end
  end
end
