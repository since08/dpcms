module ChartsHelper
  def recent_users_line_data
    Rails.cache.fetch('recent_users_line_data', expires_in: 1.hour) do
      User.group_by_day(:created_at,
                        range: 2.weeks.ago.midnight..Time.now,
                        format: '%m-%d').count
    end
  end

  def recent_weeks_users_column_data
    Rails.cache.fetch('recent_weeks_users_column_data', expires_in: 1.hour) do
      User.group_by_week(:created_at, format: '%m-%d', last: 8).count
    end
  end

  def recent_topics_line_data
    Rails.cache.fetch('recent_topics_line_data', expires_in: 1.hour) do
      UserTopic.group_by_day(:created_at,
                             range: 2.weeks.ago.midnight..Time.now,
                             format: '%m-%d').count
    end
  end

  def topic_type_pie_data
    Rails.cache.fetch('topic_type_pie_data', expires_in: 1.hour) do
      UserTopic.group(:body_type).count
    end
  end
end
