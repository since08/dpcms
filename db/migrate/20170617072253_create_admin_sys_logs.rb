class CreateAdminSysLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :admin_sys_logs do |t|
      t.references :admin_user
      t.references :operation, polymorphic: true, index: true
      t.string :action
      t.string :mark
      t.timestamps
    end
  end
end
