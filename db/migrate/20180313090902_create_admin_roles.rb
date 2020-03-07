class CreateAdminRoles < ActiveRecord::Migration[5.0]
  def change
    create_table :admin_roles do |t|
      t.string :name
      t.text :permissions
    end
  end
end
