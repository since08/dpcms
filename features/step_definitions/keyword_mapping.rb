PATH_MAPPING = {
    admin_races_path: '赛事列表页',
    new_admin_race_path: '新建赛事页',
    admin_purchase_orders_path: '订单列表页',
    admin_players_path: '牌手管理页',
    new_admin_player_path: '新建牌手页',
    new_admin_info_type_path: '新建资讯类别',
    new_admin_info_path: '新建资讯页'
}.invert

TARGET_PATH_MAPPING = {
  '/admin/races': '赛事列表页',
  '/admin/races/new': '新建赛事页',
  '/admin/races?as=票务管理': '票务管理列表页',
  '/admin/players': '牌手管理页'
}.invert

INPUT_MAPPING = {
  race_name: '赛事标题',
  race_prize: '奖池',
  race_location: '比赛地点',
  race_logo: '赛事图片',
  race_participants: '参赛人数',
  race_race_desc_attributes_description: '赛事描述',
  race_ticket_info_attributes_e_ticket_number: '总电子票数',
  order_price: '实付金额',
  email: '邮箱',
  memo: '备忘',
  e_ticket_increment: '新增电子票',
  e_ticket_decrement: '减少电子票',
  entity_ticket_increment: '新增实体票',
  entity_ticket_decrement: '减少实体票',
  player_name: '牌手姓名',
  player_country: '牌手国籍',
  player_dpi_total_earning: '牌手奖金',
  player_dpi_total_score: '牌手积分',
  race_rank_ranking: '名次',
  race_rank_earning: '赢入奖金',
  race_rank_score: '得分',
  info_type_name: '资讯类别名称',
  info_type_published: '资讯是否发布',
  info_type_level: '资讯级别',
  info_image: '资讯图片',
  info_title: '资讯名称',
  ticket_title: '赛票标题',
  ticket_price: '应付价格',
  ticket_original_price: '原始价格',
}.invert

ELEMENT_MAPPING = {
  page_title: '页面标题',
}.invert
