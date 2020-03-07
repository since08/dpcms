class AddTopicCountsToUserCounters < ActiveRecord::Migration[5.0]
  def change
    add_column :user_counters, :long_topic_count, :integer, default: 0, comment: '长帖数'
    add_column :user_counters, :short_topic_count, :integer, default: 0, comment: '说说数'
    add_column :user_counters, :great_topic_count, :integer, default: 0, comment: '精华数'
  end
end
