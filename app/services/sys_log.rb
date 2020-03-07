module Services
  class SysLog
    include Serviceable
    attr_accessor :admin_user, :operation, :action, :mark

    def initialize(admin_user, operation, action, mark = '')
      self.admin_user = admin_user
      self.action = action
      self.mark = mark
      self.operation = operation
    end

    def call
      create_params = { admin_user: admin_user,
                        action: action,
                        mark: mark }
      selectable_params = { operation: operation }
      create_params.merge! selectable_params if operation.present?
      AdminSysLog.create!(create_params)
    end
  end
end

