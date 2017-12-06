//
//  LLSMacro.h
//  LicensePlateInputView
//
//  Created by liulishuo on 2017/12/2.
//  Copyright © 2017年 liulishuo. All rights reserved.
//

#ifndef LLSMacro_h
#define LLSMacro_h

// UIScreen width.
#define  HT_ScreenWidth   [UIScreen mainScreen].bounds.size.width

// UIScreen height.
#define  HT_ScreenHeight  [UIScreen mainScreen].bounds.size.height

// iPhone X
#define  HT_iPhoneX (HT_ScreenWidth == 375.f && HT_ScreenHeight == 812.f ? YES : NO)

// Status bar height.
#define  HT_StatusBarHeight      (HT_iPhoneX ? 44.f : 20.f)

// Navigation bar height.
#define  HT_NavigationBarHeight  44.f

// Tabbar height.
#define  HT_TabbarHeight         (HT_iPhoneX ? (49.f+34.f) : 49.f)

// Tabbar safe bottom margin.
#define  HT_TabbarSafeBottomMargin         (HT_iPhoneX ? 34.f : 0.f)

// Status bar & navigation bar height.
#define  HT_StatusBarAndNavigationBarHeight  (HT_iPhoneX ? 88.f : 64.f)


#define HT_EdgeHeight (HT_iPhoneX ? 122 : 64)

#define HT_ViewSafeAreInsets(view) ({UIEdgeInsets insets; if(@available(iOS 11.0, *)) {insets = view.safeAreaInsets;} else {insets = UIEdgeInsetsZero;} insets;})

#endif /* LLSMacro_h */
