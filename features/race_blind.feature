Feature: 盲注结构
  可添加编辑删除盲注结构

  Background:
    Given 已使用 'admin@deshpro.com'登录

  Scenario: 进入赛事盲注结构，创建盲注结构
    Given 访问赛事详情页 创建数据
    And 点击链接 '盲注结构'
    And 点击链接 '新增盲注结构'
    When 点击按钮 '新增盲注结构'
    And 表单应提醒'必须大于 0' 'new_race_blind'
    And 在 'race_blind_level' 填入 '1'
    And 在 'race_blind_small_blind' 填入 '89000'
    And 在 'race_blind_big_blind' 填入 '200'
    And 在 'race_blind_ante' 填入 '200'
    And 在 'race_blind_race_time' 填入 '100'
    And 点击按钮 '新增盲注结构'
    Then 应得到成功提示 '新建成功'

  Scenario: 进入赛事盲注结构，创建文字说明
    Given 访问赛事详情页 创建数据
    And 点击链接 '盲注结构'
    And 点击链接 '新增盲注结构'
    And 在'race_blind_blind_type' 的第一个下拉框选择 '文字说明'
    When 点击按钮 '新增盲注结构'
    And 表单应提醒'必须大于 0' 'new_race_blind'
    And 表单应提醒'不能为空' 'new_race_blind'
    And 在 'race_blind_level' 填入 '1'
    And 在 'race_blind_content' 填入 'Day1 比赛日结束'
    And 点击按钮 '新增盲注结构'
    Then 应得到成功提示 '新建成功'

  Scenario: 访问赛事盲注结构，修改盲注结构类型
    Given 访问赛事盲注结构 创建数据
    And 点击链接 '编辑'
    And 在'race_blind_blind_type' 的第一个下拉框选择 '文字说明'
    When 点击按钮 '更新盲注结构'
    And 表单应提醒'不能为空' 'race_blind_content_input'
    And 在 'race_blind_content' 填入 'Day1 比赛日结束'
    And 点击按钮 '更新盲注结构'
    Then 应得到成功提示 '更新成功'