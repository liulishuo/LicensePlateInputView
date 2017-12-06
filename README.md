# LicensePlateInputView
车牌号码输入控件

![image](https://github.com/liulishuo/LicensePlateInputView/blob/master/Demo.gif)

已完成：
==============
- **设置bottomLineOffsetY**:底部边框线Y轴偏移量
- **设置bottomLineGap**:底部边框线边距
- **设置bottomLineHeight**:底部边框线高度
- **设置textFont**:文本字体
- **设置textColor**:文本颜色
- **设置generalLineColor**:底部边框线一般颜色
- **设置indicatorLineColor**:底部边框线指示颜色
- **设置初始填充文本**:
- **躲避键盘**:滚动视图上手动计算

未完成：
==============
- **躲避键盘**:IQkeyboard的效果 或者兼容IQkeyboard

要点：
==============
- **透明视图的穿透效果**:点击编辑区正常编辑，点击编辑区以外的区域dismiss键盘

使用：
==============
### 代码或者ib生成控件，设置代理，实现委托代理方法
```objc
- (void)llsLicencePlateInputView:(LLSLicencePlateInputView *)view changedText:(NSString *)text {
    NSLog(@"%@",text);
}

- (void)llsLicencePlateInputViewDidBeginEditing:(LLSLicencePlateInputView *)view;
- (void)llsLicencePlateInputViewDidEndEditing:(LLSLicencePlateInputView *)view;
```
### 键盘躲避须监听对应通知
```objc
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:LLSLicencePlateInputViewKeyboardWillHideNotification object:nil];
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:LLSLicencePlateInputViewKeyboardWillShowNotification object:nil];
```

参考：
==============
- LYPlateKeyBoardView 乐浩
- AddCarNum 常鹏阁

