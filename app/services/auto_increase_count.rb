module Services
  class AutoIncreaseCount
    include Serviceable

    def call
      TopicViewToggle.toggle_on.each do |toggle|
        next unless toggle.rule_exist?
        next unless need_update?(toggle)
        update_counters(toggle)
      end
    end

    private

    def need_update?(toggle)
      period = Time.now - toggle.last_time
      period > toggle.current_rule.interval * 60
    end

    def update_counters(toggle)
      rule = toggle.current_rule
      if rule.min_increase.eql?(rule.max_increase)
        rule.max_increase = rule.max_increase + 1
      end
      increase = rand(rule.min_increase...rule.max_increase)
      toggle.topic.increase_view_increment(increase)
      # 更新last_time
      toggle.update(last_time: Time.now)
    end
  end
end

