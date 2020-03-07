module Serviceable
  extend ActiveSupport::Concern

  module ClassMethods
    def call(*args)
      new(*args).call
    end
  end

  def error_result(error_code, msg = nil)
    ApiResult.error_result(error_code, msg)
  end
end
