# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
unless AdminUser.exists?(email: 'admin@deshpro.com')
  AdminUser.create!(email: 'admin@deshpro.com', password: 'password', password_confirmation: 'password')
end

unless AdminRole.exists?(name: '超级管理员')
  role = AdminRole.create!(name: '超级管理员', permissions: CmsAuthorization.permissions)
  admin = AdminUser.find_by(email: 'admin@deshpro.com')
  admin.admin_roles = [ role ]
  admin.save
end

unless AdminRole.exists?(name: '赛事管理员')
  permissions = %w(app_version player player_image race race_blind race_extra race_host race_rank race_schedule
                  race_tag sub_race template_type ticket ticket_info)
  AdminRole.create!(name: '赛事管理员', permissions: permissions)
end

unless AdminRole.exists?(name: '资讯管理员')
  permissions = %w(activity info info_counter info_type topic_view_rule video
                  video_counter video_group video_type)
  AdminRole.create!(name: '资讯管理员', permissions: permissions)
end

unless AdminRole.exists?(name: '运营人员')
  permissions = %w(activity admin_sys_log app_version banner bill comment crowdfunding crowdfunding_banner
crowdfunding_order crowdfunding_player crowdfunding_report dashboard feedback headline hot_info
info info_counter info_type invite_code offline_race_order player player_image poker_coin
purchase_order race race_blind race_extra race_host race_rank race_schedule race_tag release
reply reply_template sms_log sub_race template_type test_user ticket ticket_info topic_view_rule
user user_extra video video_counter video_group video_type weixin_user wx_bill album album_photo category
express_code fre_special freight option_type option_value product product_image variant product_order
product_shipment product_shipping_address product_wx_bill)

  AdminRole.create!(name: '运营人员', memo: '除了管理员修改和退款的权限', permissions: permissions)
end

unless UserTopic.exists?
  def between(one, the_other)
    rand(2).odd? ? one : the_other
  end
  (1..20).each do |i|
    published_time = Time.current + i.days
    UserTopic.create!(
      user_id: between(1, 2),
      title: "今日新闻: #{published_time}",
      body: "生活就像海洋，只有意志坚强的人才能到达彼岸",
      body_type: between('long', 'short'),
      recommended: between(true, false),
      published: true,
      published_time: published_time,
      abnormal: between(true, false),
      location: between('深圳', '广州')
    )
  end
end
