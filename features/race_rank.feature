Feature: 排行榜
  可添加编辑删除排名

  Background:
    Given 已使用 'admin@deshpro.com'登录

  Scenario: 进入赛事排行榜，创建排名
    Given 访问赛事详情页 创建数据
    And 创建牌手数据
    And 点击链接 '赛事排行榜'
    And 点击链接 '新增排名'
    And 等待 0.2 秒
    When 点击按钮 '新增排名'
    And 表单应提醒不能为空 'new_race_rank'
    And 点击链接 '搜索牌手'
    And 点击按钮 '搜索'
    And 等待 0.4 秒
    And 点击元素 '.players tbody tr'
    And 等待 0.2 秒
    And 在 '名次' 填入 '1'
    And 在 '赢入奖金' 填入 '89000'
    And 在 '得分' 填入 '200'
    And 等待 0.2 秒
    And 点击按钮 '新增排名'
    Then 应得到成功提示 '新建排名成功'

  Scenario: 进入赛事排行榜，修改排名
    Given 访问赛事排行榜 创建数据
    And 点击链接 '编辑'
    When 在 '得分' 填入 '200'
    And 点击按钮 '更新排名'
    Then 应得到成功提示 '更新排名成功'

  Scenario: 进入赛事排行榜，新建牌手
    Given 访问赛事详情页 创建数据
    And 点击链接 '赛事排行榜'
    And 点击链接 '新增排名'
    When 点击链接 '搜索牌手'
    And 点击链接 '新建牌手'
    And 点击按钮 '新增牌手'
    And 表单应提醒不能为空 'new_player'
    And 在 '牌手姓名' 填入 'breezy'
    And 在 '牌手国籍' 填入 'china'
    And 点击按钮 '新增牌手'
    And 等待 0.4 秒
    And 点击元素 '.players tbody tr'
    And 等待 0.2 秒
    And '#search_player_input input' 该选择器的值应为 'breezy'
    And 在 '名次' 填入 '1'
    And 在 '赢入奖金' 填入 '89000'
    And 在 '得分' 填入 '200'
    And 点击按钮 '新增排名'
    Then 应得到成功提示 '新建排名成功'

  Scenario: 进入赛事排行榜，修改牌手
    Given 访问赛事详情页 创建数据
    And 创建牌手数据
    When 点击链接 '赛事排行榜'
    And 点击链接 '新增排名'
    And 点击链接 '搜索牌手'
    And 点击按钮 '搜索'
    And 等待 0.2 秒
    And 点击链接 '编辑'
    And 在 '牌手姓名' 填入 'candy'
    And 点击按钮 '更新牌手'
    And 等待 0.4 秒
    And 点击元素 '.players tbody tr'
    And '#search_player_input input' 该选择器的值应为 'candy'
    And 在 '名次' 填入 '1'
    And 在 '赢入奖金' 填入 '89000'
    And 在 '得分' 填入 '200'
    And 点击按钮 '新增排名'
    Then 应得到成功提示 '新建排名成功'