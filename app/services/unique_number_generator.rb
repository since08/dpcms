##
# 唯一编号生成器
# model              需要产生的单号的model
# key                model中被唯一的编号字段
# incr_min_length   增加量的最小长度
#
# return 只返回数字字符
module Services
  class UniqueNumberGenerator
    include Serviceable
    attr_accessor :model, :key, :incr_min_length
    MODE_PREFIX_MAP = {
      PurchaseOrder: '1',
      ProductOrder: '2'
    }.freeze
    def initialize(model, key = :order_number, incr_min_length = 5)
      self.model = model
      self.key = key
      self.incr_min_length = incr_min_length
    end

    def call
      "#{number_prefix}#{padded_today_increment}"
    end

    def number_prefix
      "#{MODE_PREFIX_MAP.fetch(model.name.to_sym)}#{current_time_prefix}"
    end

    def padded_today_increment
      today_increment.to_s.rjust(incr_min_length, '0')
    end

    def today_increment
      if Rails.cache.exist?(today_cache_key, raw: true)
        return Rails.cache.increment(today_cache_key)
      end
      set_today_increment
    end

    def set_today_increment
      if today_record_exist? # rubocop:disable Style/ConditionalAssignment
        current_increment = restore_today_increment
      else
        current_increment = Rails.cache.increment(today_cache_key)
      end
      Rails.cache.expire(today_cache_key, 1.day)
      current_increment
    end

    def restore_today_increment
      last_increment = last_record_number[number_prefix.size..-1].to_i
      Rails.cache.increment(today_cache_key, last_increment + 1)
    end

    def today_record_exist?
      today_prefix_len = number_prefix.size - 4
      last_record_number &&
        last_record_number.first(today_prefix_len) == number_prefix.first(today_prefix_len)
    end

    def last_record_number
      @record_number ||= model.last&.send(key)
    end

    def today_cache_key
      "#{model}::#{key}::#{today_str}::increment"
    end

    def today_str
      @today_str ||= Time.current.strftime('%Y%m%d')
    end

    def current_time_prefix
      @current_time_prefix ||= Time.current.strftime('%y%m%d%H%M')
    end
  end
end
