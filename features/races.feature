Feature: 赛事首页
  登录成功后，应能进入赛事首页管理

  Background:
    Given 已使用 'admin@deshpro.com'登录

  Scenario: 赛事列表中点击新建赛事
    Given 访问 '赛事列表页'
    When 点击链接 '新建赛事'
    Then 应到达 '新建赛事页'

  Scenario: 赛事列表中点击新建赛事
    Given 访问 '新建赛事页'
    When 在 '赛事标题' 填入 '2017传奇扑克超高额豪客赛'
    When 在 'race_race_en_attributes_name' 填入 '2017 poker event'
    And 在 '奖池' 填入 '888888'
    And 在 '比赛地点' 填入 '中国澳门'
    And 在 '赛事图片' 上传图片
    And 在编辑器中 '#markdown_cn .simditor-body' 填入 '中国澳门'
    And 在编辑器中 '#markdown_en .simditor-body' 填入 'macau, china'
    And 点击按钮 '新建赛事'
    Then '页面标题' 应看到 '2017传奇扑克超高额豪客赛'
    And 应创建了对应的英文赛事
    And 调用api 应无法获取该赛事详情

  Scenario: 赛事列表中更新状态
    Given 访问赛事列表页 创建数据
    Then 调用api 应成功获取该赛事详情
    When 在'status' 的第一个下拉框选择 '已关闭'
    And 确定alert
    Then 调用api 应成功获取该赛事详情

  Scenario: 赛事详情中点击发布赛事
    Given 访问 '新建赛事页'
    When 在 '赛事标题' 填入 '2017传奇扑克超高额豪客赛'
    And 在 '奖池' 填入 '888888'
    And 在 '比赛地点' 填入 '中国澳门'
    And 在 '赛事图片' 上传图片
    And 点击按钮 '新建赛事'
    Then 调用api 应无法获取该赛事详情
    And 点击链接 '发布赛事'
    And 调用api 应成功获取该赛事详情

  Scenario: 赛事详情-取消发布
    Given 访问赛事详情页 创建数据
    And 调用api 应成功获取该赛事详情
    And 点击链接 '取消发布'
    Then 调用api 应无法获取该赛事详情

  Scenario: 赛事详情-删除赛事
    Given 访问赛事详情页 创建数据
    And 调用api 应成功获取该赛事详情
    And 点击链接 '取消发布'
    And 点击链接 '删除赛事'
    When 对话框中点击 '确定'
    Then 应到达 '赛事列表页'

  Scenario: 编辑赛事详情
    Given 访问赛事详情页 创建数据
    And 调用api 应成功获取该赛事详情
    And 点击链接 '编辑赛事'
    When 在 '赛事标题' 填入 '2017传奇扑克超高额豪客赛'
    And 在 'race_race_en_attributes_logo' 上传图片
    And 在 'race_race_en_attributes_name' 填入 '2017 poker event'
    And 在编辑器中 '#markdown_cn .simditor-body' 填入 '中国澳门'
    And 在编辑器中 '#markdown_en .simditor-body' 填入 'macau, china'
    And 点击按钮 '更新赛事'
    Then 调用api 应成功获取该赛事详情，并且内容一致
    And 应创建了对应的英文赛事
