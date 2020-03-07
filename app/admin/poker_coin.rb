ActiveAdmin.register PokerCoin do
  menu priority: 25
  config.clear_action_items!

  filter :typeable_type
  filter :typeable_id
  filter :user_nick_name, as: :string
  filter :user_mobile, as: :string
  filter :memo
  filter :number
  filter :created_at

  index do
    render 'index', context: self
  end

  member_action :coin, method: [:get, :post] do
    @max_coin = PokerCoin.total_coin_of_the_type(resource.typeable, resource.user)
    return render 'coin' unless request.post?

    number = params[:number].to_i
    return render 'params_blank' if number <= 0 || params[:memo].blank?
    number = params[:direction].eql?('decrease') ? -number : number
    return render 'over_number' if params[:direction].eql?('decrease') && @max_coin < -number
    # 添加记录
    PokerCoin.create(user: resource.user,
                     typeable: resource.typeable, orderable: resource.orderable, memo: params[:memo], number: number)
    # 记录操作日志
    Services::SysLog.call(current_admin_user, resource,
                          '扑客币手动修改', "类型：#{resource.typeable_type}，相关的用户：#{resource.user&.nick_name}，扑客币数量： #{number}")
    render 'common/update_success'
  end
end
