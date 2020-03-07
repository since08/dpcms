Feature: 订单首页
  登录成功后，应能进入订单首页管理

  Background:
    Given 已使用 'admin@deshpro.com'登录
    And 创建用户订单

  Scenario: 点击订单列表
    When 访问 '订单列表页'
    Then 应该能找到 '王石,待付款' 这些信息

  Scenario: 取消订单
    When 访问 '订单列表页'
    When 点击链接 '取消'
    And 对话框中点击 '确定'
    Then 应该能找到 '已取消' 这些信息

  Scenario: 修改金额
    When 访问 '订单列表页'
    And 点击链接 '编辑'
    And 点击按钮 '修改金额'
    And 在 '实付金额' 填入 '1024'
    And 点击按钮 '保存'
    And 对话框中点击 '确定'
    And 确定alert
    Then 应该能找到 '1024' 这些信息

  Scenario: 审核不通过
    When 访问 '订单列表页'
    And 点击链接 '编辑'
    And 点击按钮或链接 '审核不通过'
    And 在 '备忘' 填入 '任性不让通过'
    And 点击按钮或链接 '提交'
    And 对话框中点击 '确定'
    And 确定alert
    Then 应该能找到 '任性不让通过' 这些信息

  Scenario: 审核通过
    When 访问 '订单列表页'
    And 点击链接 '编辑'
    And 点击按钮或链接 '审核通过'
    And 对话框中点击 '确定'
    And 确定alert
    Then 应该能找到 '已实名' 这些信息

  Scenario: 修改收货信息
    When 访问 '订单列表页'
    And 点击链接 '编辑'
    And 点击按钮或链接 '修改'
    And 在 '邮箱' 填入 'test@deshpro.com'
    And 点击按钮或链接 '更新'
    And 对话框中点击 '确定'
    And 确定alert
    Then 应该能找到 'test@deshpro.com' 这些信息

  Scenario: 待付款 -> 已付款   已付款 -> 已发货
    When 访问 '订单列表页'
    And 点击链接 '编辑'
    And 点击按钮或链接 '审核通过'
    And 对话框中点击 '确定'
    And 确定alert
    And 等待 1 秒
    And 点击按钮或链接 '确认已付款'
    And 对话框中点击 '确定'
    And 确定alert
    Then 应该能找到 '待发货' 这些信息
    And 点击按钮或链接 '确认发货'
    And 对话框中点击 '确定'
    And 确定alert
    Then 应该能找到 '已发货' 这些信息
