module DpPush
  class NotifyUser
    def initialize(user, msg)
      @push = DpPush::Push.new
      @user = user
      @msg = msg
    end

    def self.call(*args)
      new(*args).call
    end

    def call
      @push.push(push_payload)
    rescue => e
      Rails.logger.error "DpPush: #{e}"
    end

    def push_payload
      @push.payload(
        platform: 'all',
        audience: audience,
        notification: notification
      ).set_options(options)
    end

    def options
      # True 表示推送生产环境，False 表示要推送开发环境
      { apns_production: ENV['JPUSH_APNS_PRODUCTION'] }
    end

    def audience
      push_alias = "#{ENV['CURRENT_PROJECT_ENV']}_#{@user.user_uuid}"
      @push.audience.set_alias(push_alias)
    end

    def notification
      @push.notification
           .set_alert(@msg)
           .set_ios(sound: 'sound',
                    alert: @msg,
                    contentavailable: true,
                    badge: '+1')
    end
  end
end