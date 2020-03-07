Feature: 资讯类别管理
  登录成功后，可进行资讯类别管理

  Background:
    Given 已使用 'admin@deshpro.com'登录

  Scenario: 资讯类别管理-资讯类别列表
    When 访问资讯类别管理页 创建数据
    Then 应该能找到 '新闻_' 这些信息

  Scenario: 资讯类别管理-新建资讯类别
    When 访问 '新建资讯类别'
    And 在 '资讯类别名称' 填入 '新闻'
    And 在 '资讯级别' 填入 '2'
    And 点击按钮或链接 '新建资讯类别'
    Then 应该能找到 '名称,新闻,是否发布,否,级别,2' 这些信息

  Scenario: 资讯类别管理-发布资讯
    When 访问资讯类别管理页 创建数据
    And 点击按钮或链接 '取消发布'
    And 确定alert
    Then 应该能找到 '取消发布成功,否' 这些信息

  Scenario: 资讯类别管理-发布资讯
    When 访问资讯类别管理页 创建数据
    And 点击按钮或链接 '取消发布'
    And 确定alert
    And 点击按钮或链接 '发布'
    And 确定alert
    Then 应该能找到 '发布成功,是' 这些信息

  Scenario: 资讯类别管理-编辑资讯
    When 访问资讯类别管理页 创建数据
    And 点击按钮或链接 '编辑'
    And 在 '资讯类别名称' 填入 '测试'
    And 在 '资讯级别' 填入 '3'
    And 点击按钮或链接 '更新资讯类别'
    Then 应该能找到 '名称,测试,级别,3' 这些信息


