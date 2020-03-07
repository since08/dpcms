Feature: 票务管理
  登录后，可进行票务管理

  Background:
    Given 已使用 'admin@deshpro.com'登录

  Scenario: 进入票务管理列表
    Given 访问赛事详情页 创建数据
    And 点击链接 '票务管理'
    And 点击链接 '新建赛票'
    When 在 '赛票标题' 填入 '飞机票 + 017APT启航站主票'
    And 在 'ticket_ticket_en_attributes_title' 填入 'air ticket and event ticket'
    And 在 '原始价格' 填入 '10000'
    And 在 '应付价格' 填入 '10000'
    And 在'ticket_ticket_class' 的第一个下拉框选择 '套票'
    And 在编辑器中 '#markdown_cn .simditor-body' 填入 '中国澳门'
    And 在编辑器中 '#markdown_en .simditor-body' 填入 'macau, china'
    And 点击按钮 '新建赛票'
    And 在'ticket_status' 的第一个下拉框选择 '售票中'
    Then 调用api 应成功获取该票务详情
    And 应创建了对应的英文票务

  Scenario: 修改票务详情
    Given 访问赛事详情页 创建数据
    And 点击链接 '票务管理'
    And 点击链接 '新建赛票'
    And 在 '赛票标题' 填入 '飞机票 + 017APT启航站主票'
    And 在 '原始价格' 填入 '10000'
    And 在 '应付价格' 填入 '10000'
    And 在'ticket_ticket_class' 的第一个下拉框选择 '套票'
    And 点击按钮 '新建赛票'
    When 点击链接 '编辑赛票'
    And 在 'ticket_ticket_en_attributes_title' 填入 'air ticket and event ticket'
    And 在编辑器中 '#markdown_cn .simditor-body' 填入 '中国澳门'
    And 在编辑器中 '#markdown_en .simditor-body' 填入 'macau, china'
    And 点击按钮 '更新赛票'
    And 在'ticket_status' 的第一个下拉框选择 '售票中'
    Then 调用api 应成功获取该票务详情
    And 应创建了对应的英文票务

  Scenario: 修改票务的价格，英文票务中的价格应该同步
    Given 访问赛事详情页 创建数据
    And 点击链接 '票务管理'
    And 点击链接 '新建赛票'
    And 在 '赛票标题' 填入 '飞机票 + 017APT启航站主票'
    And 在 '原始价格' 填入 '10000'
    And 在 '应付价格' 填入 '10000'
    And 在'ticket_ticket_class' 的第一个下拉框选择 '套票'
    And 点击按钮 '新建赛票'
    When 点击链接 '编辑赛票'
    And 在 '原始价格' 填入 '28888'
    And 在 '应付价格' 填入 '28888'
    And 点击按钮 '更新赛票'
    Then 英文票务与中文票务的价格应一致，都应为 '28888'


  Scenario: 票务管理详情页新增电子票
    Given 访问赛事详情页 创建数据
    When 点击链接 '票务管理'
    When 点击链接 '查看'
    And 新增电子票 '3' 张
    Then 电子票票数应变成 '53' 张

  Scenario: 票务管理详情页减少电子票
    Given 访问赛事详情页 创建数据
    When 点击链接 '票务管理'
    When 点击链接 '查看'
    And 减少电子票 '10' 张
    Then 电子票票数应变成 '40' 张

  Scenario: 票务管理详情页减少电子票失败
    Given 访问赛事详情页 创建数据
    When 点击链接 '票务管理'
    When 点击链接 '查看'
    And 减少电子票 '60' 张
    Then 应得到错误提示 '减去的票数不允许大于剩余的票数'

  Scenario: 票务管理详情页新增实体票
    Given 访问赛事详情页 创建数据
    When 点击链接 '票务管理'
    When 点击链接 '查看'
    And 新增实体票 '3' 张
    Then 实体票票数应变成 '53' 张

  Scenario: 票务管理详情页减少实体票
    Given 访问赛事详情页 创建数据
    When 点击链接 '票务管理'
    When 点击链接 '查看'
    And 新增实体票 '3' 张
    Then 实体票票数应变成 '53' 张
    And 减少实体票 '2' 张
    Then 实体票票数应变成 '51' 张

  Scenario: 票务管理详情页减少实体票失败
    Given 访问赛事详情页 创建数据
    When 点击链接 '票务管理'
    When 点击链接 '查看'
    And 新增实体票 '3' 张
    Then 实体票票数应变成 '53' 张
    And 减少实体票 '62' 张
    Then 应得到错误提示 '减去的票数不允许大于剩余的票数'
