class AddMemoToAdminRole < ActiveRecord::Migration[5.0]
  def change
    add_column :admin_roles, :memo, :string
  end
end
