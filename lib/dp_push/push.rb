module DpPush
  class Push
    def initialize
      app_key = ENV['JPUSH_APP_KEY']
      master_secret = ENV['JPUSH_MASTER_SECRET']
      @push = JPush::Client.new(app_key, master_secret)
    end

    def push(*args)
      @push.pusher.push(*args)
    end

    def payload(*args)
      JPush::Push::PushPayload.new(*args)
    end

    def audience
      JPush::Push::Audience.new
    end

    def notification
      JPush::Push::Notification.new
    end
  end
end