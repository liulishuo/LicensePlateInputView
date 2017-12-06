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
@property (nonatomic, assign) CGFloat bottomLineOffsetY;
@property (nonatomic, assign) CGFloat bottomLineGap;
@property (nonatomic, assign) CGFloat bottomLineHeight;
@property (nonatomic, strong) UIFont *textFont;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *generalLineColor;
@property (nonatomic, strong) UIColor *indicatorLineColor;

- (void)setCarNumber:(NSString *)carNumber;

@end
