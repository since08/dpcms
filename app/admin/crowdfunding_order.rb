# rubocop:disable Metrics/BlockLength
ActiveAdmin.register CrowdfundingOrder do
  menu priority: 21, parent: '众筹管理', label: '众筹订单'
  config.batch_actions = false
  config.filters = false
  actions :all, except: [:new]

  index do
    id_column
    column :order_number
    column :created_at
    column '用户' do |order|
      link_to order.user.nick_name, admin_user_url(order.user), target: '_blank'
    end
    column '赛事名称' do |order|
      link_to order.crowdfunding.race.name,
              admin_crowdfunding_crowdfunding_players_url(order.crowdfunding_id),
              target: '_blank'
    end
    column '牌手名' do |order|
      order.crowdfunding_player.player.name
    end
    column :order_stock_money
    column :order_stock_number
    column :total_money
    column :deduction_price
    column :final_price
    column :pay_time
    column :paid
    column :record_status, sortable: false do |order|
      I18n.t("crowdfunding_order.#{order.record_status}")
    end
    column '扑克币' do |order|
      if order.crowdfunding_player.completed? && order.crowdfunding_player.crowdfunding_rank
        order.crowdfunding_player.crowdfunding_rank.unit_amount * order.order_stock_number
      else
        '-'
      end
    end
    # actions name: '操作', defaults: false do |order|
    #   item '查看', admin_crowdfunding_order_path(order), class: 'member_link'
    # end
  end
end
