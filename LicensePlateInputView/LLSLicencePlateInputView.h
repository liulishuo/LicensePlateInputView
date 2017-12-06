//
//  VKLicencePlateInputView.h
//  Keyboard
//
//  Created by liulishuo on 2017/11/22.
//  Copyright © 2017年 liulishuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLSNotificationName.h"

@class LLSLicencePlateInputView;
@protocol LLSLicencePlateInputViewDelegate <NSObject>

@optional
- (void)llsLicencePlateInputViewDidBeginEditing:(LLSLicencePlateInputView *)view ;
- (void)llsLicencePlateInputViewDidEndEditing:(LLSLicencePlateInputView *)view ;

@required
- (void)llsLicencePlateInputView:(LLSLicencePlateInputView *)view changedText:(NSString *)text;

@end

@interface LLSLicencePlateInputView : UIView

@property (nonatomic, strong, readonly) NSString *carNumStr;
@property (nonatomic, weak) UIViewController<LLSLicencePlateInputViewDelegate> *delegate;
@property (nonatomic, assign) CGFloat bottomLineOffsetY;//底部边框线Y轴偏移量
@property (nonatomic, assign) CGFloat bottomLineGap;//底部边框线边距
@property (nonatomic, assign) CGFloat bottomLineHeight;//底部边框线高度
@property (nonatomic, strong) UIFont *textFont;//文本字体
@property (nonatomic, strong) UIColor *textColor;//文本颜色
@property (nonatomic, strong) UIColor *generalLineColor;//底部边框线一般颜色
@property (nonatomic, strong) UIColor *indicatorLineColor;//底部边框线指示颜色

- (void)setCarNumber:(NSString *)carNumber;//填充文本

@end
