# NAISICodeCov
- 简述：`iOS` 集成测试覆盖率，负责收集 `gcda` 文件及上传服务器部分
- 效果展示
- 使用方法
  - `Podfile` 文件中适当的位置增加以下内容：
    ```ruby
    pod 'NAISICodeCov', :path => 'NAISICodeCov', :configurations => 'configuration name'
    # or 
    pod 'NAISICodeCov', :path => 'NAISICodeCov', :configurations => ['configuration name', 'configuration name']    # 添加多个 `configuration name`，最好不要将 Release 添加进去
    ```
  - `pod install`

