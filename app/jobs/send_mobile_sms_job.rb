# 发送短信验证码任务
class SendMobileSmsJob < ApplicationJob
  queue_as :default

  def perform(sms_type, mobile, content)
    logger = Resque.logger
    logger.info "[SendMobileSmsJob] Send #{sms_type} SMS to #{mobile} content [#{content}]"
    Qcloud::SmsGateway::SendSms.send(mobile, content)
  end
end
