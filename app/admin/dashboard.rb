# rubocop:disable Metrics/BlockLength
ActiveAdmin.register_page 'Dashboard' do
  menu false
  content title: I18n.t('active_admin.dashboard') do
    h3 '以下图表数据每小时更新一次', style: 'text-align: center; padding: 20px'

    columns do
      column do
        panel '最近两周新增app用户数' do
          ul do
            line_chart recent_users_line_data
          end
        end
      end

      column do
        panel '最近八周新增app用户数' do
          ul do
            column_chart recent_weeks_users_column_data
          end
        end
      end
    end

    columns do
      column do
        panel '最近两周新增说说与帖子数' do
          ul do
            line_chart recent_topics_line_data
          end
        end
      end

      column do
        panel '说说与帖子数的比重' do
          ul do
            pie_chart topic_type_pie_data
          end
        end
      end
    end
  end # content
end
