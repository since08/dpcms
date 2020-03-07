# rubocop:disable Metrics/BlockLength
ActiveAdmin.register CrowdfundingPlayer do
  belongs_to :crowdfunding
  permit_params :player_id, :join_slogan, :sell_stock, :stock_number,
                :stock_unit_price, :limit_buy, :published,
                player_attributes: [:id, :lairage_rate, :final_rate, :nick_name, :description, :logo]
  config.clear_action_items!

  form partial: 'form'

  filter :player_name, as: :string
  filter :player_nick_name, as: :string

  index do
    render 'index', context: self
  end

  collection_action :select_player, method: :get do
  end

  collection_action :player_lists, method: :get do
    keyword = params[:content].to_s
    like_sql = 'name like ? or nick_name like ?'
    @crowdfunding = Crowdfunding.find(params[:crowdfunding_id])
    @players = Player.where(like_sql, "%#{keyword}%", "%#{keyword}%").order(id: :desc).page(params[:page]).per(8)
  end

  action_item :select_player, only: :index do
    link_to '新建牌手', select_player_admin_crowdfunding_crowdfunding_players_path, remote: true
  end

  member_action :publish, method: :post do
    resource.publish!
    redirect_back fallback_location: admin_crowdfunding_crowdfunding_players_url, notice: '发布成功'
  end

  member_action :unpublish, method: :post do
    resource.unpublish!
    redirect_back fallback_location: admin_crowdfunding_crowdfunding_players_url, notice: '取消发布成功'
  end

  member_action :poker_coin, method: [:get, :post] do
    return render 'poker_coin' unless request.post?
    orders = resource.crowdfunding_orders.paid_status
    rank = resource.crowdfunding_rank
    orders.each do |order|
      number = (rank.unit_amount * order.order_stock_number) * 100
      PokerCoin.create(user: order.user, typeable: resource, memo: '众筹成功', number: number)
      order.update(poker_coins: number)
    end
    resource.completed!
    redirect_back fallback_location: admin_crowdfunding_crowdfunding_players_url, notice: '下发成功'
  end

  member_action :result, method: [:get, :post] do
    return render 'result' unless request.post?
    return render 'common/params_format_error' if params[:ranking].blank?
    return render 'common/tax_format_error' if params[:platform_tax].to_i > 100
    CrowdfundingRank.where(crowdfunding_player: resource)
                    .update_or_create(crowdfunding: @crowdfunding,
                                      crowdfunding_player: resource,
                                      race: @crowdfunding.race,
                                      player: resource.player,
                                      ranking: params[:ranking],
                                      awarded: params[:awarded],
                                      finaled: params[:finaled],
                                      earning: params[:earning],
                                      deduct_tax: params[:deduct_tax],
                                      platform_tax: params[:platform_tax])
    if params[:awarded].eql?('false') && params[:finaled].eql?('false')
      resource.crowdfunding_orders.paid_status.each(&:failed!)
      resource.failed!
    else
      resource.crowdfunding_orders.paid_status.each(&:success!)
      resource.success!
    end
    render 'common/update_success'
  end

  controller do
    before_action :set_crowdfunding
    def new
      @crowdfunding_player = CrowdfundingPlayer.new(crowdfunding: @crowdfunding,
                                                    player: Player.find(params[:player_id]))
    end

    private

    def set_crowdfunding
      @crowdfunding = Crowdfunding.find(params[:crowdfunding_id])
    end
  end
end
