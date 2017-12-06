


#define HEXCOLOR(hex, alp) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:alp]

#define KEYBOARD_RATIO (1/3.0)

#import "LLSPlateKeyBoardView.h"
#import "LLSMacro.h"
#import "LLSNotificationName.h"

@interface LLSPlateKeyBoardView()

@property (nonatomic, strong) NSArray *array1;
@property (nonatomic, strong) NSArray *array2;
@property (nonatomic, strong) UIView *keyboardView1;
@property (nonatomic, strong) UIView *keyboardView2;

@end

@implementation LLSPlateKeyBoardView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        _isHidden = YES;
        [self setup];
    }
    return self;
}
#pragma mark - Event Response
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@"%@%@",NSStringFromCGPoint(point),event);
    UIView *view = [super hitTest:point withEvent:event];
    if (view == self) {
        if (event.allTouches == nil) {
            return nil;
        }
        UIView *inputView = (UIView *)_delegate;
        //转换至VKLicencePlateInputView控件坐标系
        CGPoint hitPoint = [self convertPoint:point toView:inputView];
        //判断触摸是否在VKLicencePlateInputView控件范围内
        BOOL flag = [inputView pointInside:hitPoint withEvent:event];
        //如果不是 dismiss键盘
        if (flag == NO) {
            [self hide];
        }
        return nil;
    }
    
    return view;
}

- (void)keyboard1BtnClick:(UIButton *)sender {
    NSInteger index = sender.tag - 100;
    if (index == 30) {
        NSLog(@"点击了abc键");
        self.type = LLSPlateKeyBoardViewTypeLetter;
    }else if (index == 38){
        NSLog(@"点击了删除键");
        if (_keyboardView2.hidden) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(llsPlateKeyBoardViewDidDelete:)]) {
                [self.delegate llsPlateKeyBoardViewDidDelete:self];
            }
        }
    }else {
        self.type = LLSPlateKeyBoardViewTypeLetter;
        if (self.delegate && [self.delegate respondsToSelector:@selector(llsPlateKeyBoardView:didSelectString:)]) {
            [self.delegate llsPlateKeyBoardView:self didSelectString:_array1[index]];
        }
    }
}

- (void)keyboard2BtnClick:(UIButton *)sender {
    NSInteger index = sender.tag - 100;
    if (index == 29) {
        NSLog(@"点击了abc键");
        self.type = LLSPlateKeyBoardViewTypeChinese;
    }else if (index == 37) {
        NSLog(@"点击了删除键");
        if (self.delegate && [self.delegate respondsToSelector:@selector(llsPlateKeyBoardViewDidDelete:)]) {
            [self.delegate llsPlateKeyBoardViewDidDelete:self];
        }
    }else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(llsPlateKeyBoardView:didSelectString:)]) {
            [self.delegate llsPlateKeyBoardView:self didSelectString:_array2[index]];
        }
    }
}

//- (NSNotification *)packInfo {
//    //  Getting keyboard animation.
////    CGRect rect = _keyboardView1.bounds;
////    NSValue *rectValue = [NSValue valueWithCGRect:rect];
////    CGRect rect2 = CGRectMake(0, self.frame.size.height / 3 * 2, _keyboardView1.bounds.size.width, _keyboardView1.bounds.size.height);
////    NSValue *rectValue2 = [NSValue valueWithCGRect:rect2];
//
//    CGRect rect = CGRectMake(0, 0, 414, 315);
//    CGRect rect1 = CGRectMake(0, 466, 414, 270);
//    CGRect rect2 = CGRectMake(0, 421, 414, 315);
//
//    NSValue *value = [NSValue valueWithCGRect:rect];
//    NSValue *value1 = [NSValue valueWithCGRect:rect1];
//    NSValue *value2 = [NSValue valueWithCGRect:rect2];
//
//    CGPoint point = CGPointMake(207, 601);
//    CGPoint point1 = CGPointMake(207, 578.5);
//
//    NSValue *value3 = [NSValue valueWithCGPoint:point];
//    NSValue *value4 = [NSValue valueWithCGPoint:point1];
//
//   NSDictionary *userInfo = @{
//       UIKeyboardAnimationCurveUserInfoKey : @7,
//       UIKeyboardAnimationDurationUserInfoKey : @0.25,
//       UIKeyboardBoundsUserInfoKey : value,
//       UIKeyboardCenterBeginUserInfoKey : value3,
//       UIKeyboardCenterEndUserInfoKey : value4,
//       UIKeyboardFrameBeginUserInfoKey : value1,
//       UIKeyboardFrameEndUserInfoKey : value2,
//       UIKeyboardIsLocalUserInfoKey : @1,
//                              };
//
//    NSNotification *noti = [[NSNotification alloc] initWithName:UIKeyboardWillShowNotification object:nil userInfo:userInfo];
//
//    return noti;
//}

- (void)hide {
    id target = [self currentKeyboard];
    [[NSNotificationCenter defaultCenter] postNotificationName:LLSLicencePlateInputViewKeyboardWillHideNotification object:target];
//    NSNotification *info = [self packInfo];
//    [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardWillHideNotification object:info];
    
    if (_isHidden == NO) {
        _isHidden = YES;
        CGSize size = self.frame.size;
        
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = _keyboardView1.frame;
            frame.origin.y = size.height;
            
            _keyboardView1.frame = frame;
            _keyboardView2.frame = frame;
        } completion:^(BOOL finished) {
        }];
    }
}

- (void)show {
    id target = [self currentKeyboard];
//    NSNotification *info = [self packInfo];
//[[NSNotificationCenter defaultCenter] postNotification:info];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:LLSLicencePlateInputViewKeyboardWillShowNotification object:target];
    
    if (_isHidden == YES) {
        _isHidden = NO;
        CGSize size = self.frame.size;
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = _keyboardView1.frame;
            frame.origin.y = size.height - size.height * KEYBOARD_RATIO - HT_TabbarSafeBottomMargin;
            _keyboardView1.frame = frame;
            _keyboardView2.frame = frame;
        }];
    }
}
#pragma mark - Delegate
#pragma mark - Methods
- (void)setup {
    [self setupDataSource];
    [self setupUI];
}

- (void)setupDataSource {
    _array1 = @[@"京",@"沪",@"粤",@"津",@"冀",@"晋",@"蒙",@"辽",@"吉",@"黑",@"苏",@"浙",@"皖",@"闽",@"赣",@"鲁",@"豫",@"鄂",@"湘",@"桂",@"琼",@"渝",@"川",@"贵",@"云",@"藏",@"陕",@"甘",@"青",@"宁",@"",@"新",@"使",@"领",@"警",@"学",@"港",@"澳",@""];
    _array2 = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0",@"Q",@"W",@"E",@"R",@"T",@"Y",@"U",@"I",@"O",@"P",@"A",@"S",@"D",@"F",@"G",@"H",@"J",@"K",@"L",@"",@"Z",@"X",@"C",@"V",@"B",@"N",@"M",@""];
}

- (UIView *)creatContentView {
    CGSize size = self.frame.size;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, size.height, size.width, size.height * KEYBOARD_RATIO + HT_TabbarSafeBottomMargin)];
    view.backgroundColor = HEXCOLOR(0xd2d5da, 1);
    return view;
}

- (UIButton *)creatButtonAtIndex:(NSInteger)index {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:HEXCOLOR(0x23262F, 1) forState:UIControlStateNormal];
    btn.layer.cornerRadius = 3;
    btn.layer.masksToBounds = YES;
    return btn;
}

- (void)setupUI {
    _keyboardView1 = [self creatContentView];
    [self addSubview:_keyboardView1];
    
    _keyboardView2 = [self creatContentView];
    [self addSubview:_keyboardView2];
    
    self.type = LLSPlateKeyBoardViewTypeChinese;
    
    CGSize size = self.frame.size;
    int row = 4;//行数
    int column = 10;//每行的列数
    CGFloat keyboardTopMargin = 10;//键盘上边距
    CGFloat keyboardBottomMargin = 2;//键盘下边距
    CGFloat keyboardHorizontalMargin = 2;//键盘左右边距
    CGFloat rowGap = 10;//行间距
    CGFloat columnGap = 5;//列间距
    
    CGFloat specialButtonExtraWidth = 12;//特殊按钮的额外宽度
    CGFloat specialColumnGap = 12;//特殊按钮的列间距
    //按钮宽度
    CGFloat btnW = (size.width - columnGap * (column -1) - 2 * keyboardHorizontalMargin) / column;
    //按钮高度
    CGFloat btnH = (_keyboardView1.frame.size.height - rowGap * (row - 1) - keyboardTopMargin - keyboardBottomMargin - HT_TabbarSafeBottomMargin) / row;
    
    CGFloat specialKeyboardHorizontalOffset = btnW / 2;
    
    NSInteger index = 0;
    
    for (int i = 0; i < row; i ++) {
        if (i == 3) {
            column = 9;
        }
        
        for (int j = 0; j < column; j ++) {
            CGFloat x = keyboardHorizontalMargin + j * (btnW + columnGap);
            CGFloat y = keyboardTopMargin + i * (btnH + rowGap);
            
            UIButton *btn = [self creatButtonAtIndex:index];
            [btn setTitle:_array1[index] forState:UIControlStateNormal];
            btn.frame = CGRectMake(x, y, btnW, btnH);
            btn.tag = index + 100;
            [btn addTarget:self action:@selector(keyboard1BtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_keyboardView1 addSubview:btn];
            
            if (i == 3) {
                if (j == 0) {
                    [btn setBackgroundImage:[UIImage imageNamed:@"key_abc"] forState:UIControlStateNormal];
                    btn.frame = CGRectMake(x, y, btnW + specialButtonExtraWidth, btnH);
                } else if (j == 8) {
                    [btn setBackgroundImage:[UIImage imageNamed:@"key_over"] forState:UIControlStateNormal];
                    btn.frame = CGRectMake(keyboardHorizontalMargin + btnW + specialButtonExtraWidth + specialColumnGap + (j - 1) * (btnW + columnGap) + specialColumnGap - columnGap, y, btnW + specialButtonExtraWidth, btnH);
                } else {
                    [btn setBackgroundImage:[UIImage imageNamed:@"key_number"] forState:UIControlStateNormal];
                    btn.frame = CGRectMake(keyboardHorizontalMargin + btnW + specialButtonExtraWidth + specialColumnGap + (j - 1) * (btnW + columnGap), y, btnW, btnH);
                }
            } else {
                [btn setBackgroundImage:[UIImage imageNamed:@"key_number"] forState:UIControlStateNormal];
            }
            
            index ++;
        }
    }
    
    column = 10;
    index = 0;
    
    for (int i = 0; i < row; i ++) {
        if (i == 2) {
            column = 9;
        }
        
        for (int j = 0; j < column; j ++) {
            CGFloat x = keyboardHorizontalMargin + j * (btnW + columnGap);
            CGFloat y = keyboardTopMargin + i * (btnH + rowGap);
            
            UIButton *btn = [self creatButtonAtIndex:index];
            [btn setTitle:_array2[index] forState:UIControlStateNormal];
            btn.frame = CGRectMake(x, y, btnW, btnH);
            btn.tag = index + 100;
            [btn addTarget:self action:@selector(keyboard2BtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_keyboardView2 addSubview:btn];
            
             if (i == 3) {
                if (j == 0) {
                    [btn setBackgroundImage:[UIImage imageNamed:@"key_abc"] forState:UIControlStateNormal];
                    btn.frame = CGRectMake(x, y, btnW + specialButtonExtraWidth, btnH);
                } else if (j == 8) {
                    [btn setBackgroundImage:[UIImage imageNamed:@"key_over"] forState:UIControlStateNormal];
                    btn.frame = CGRectMake(keyboardHorizontalMargin + btnW + specialButtonExtraWidth + specialColumnGap + (j - 1) * (btnW + columnGap) + specialColumnGap - columnGap, y, btnW + specialButtonExtraWidth, btnH);
                } else {
                    [btn setBackgroundImage:[UIImage imageNamed:@"key_number"] forState:UIControlStateNormal];
                    btn.frame = CGRectMake(keyboardHorizontalMargin + btnW + specialButtonExtraWidth + specialColumnGap + (j - 1) * (btnW + columnGap), y, btnW, btnH);
                }
            } else {
                [btn setBackgroundImage:[UIImage imageNamed:@"key_number"] forState:UIControlStateNormal];
                if (i == 2) {
                    btn.frame = CGRectMake(x + specialKeyboardHorizontalOffset, y, btnW, btnH);
                }
            }
            
            index ++;
        }
    }
    
    [self show];
}

- (id)currentKeyboard {
    id target = nil;
    if (_keyboardView1.isHidden == NO) {
        target = _keyboardView1;
    } else if (_keyboardView2.isHidden == NO) {
        target = _keyboardView2;
    }
    
    return target;
}

#pragma mark - Setter and Getter
- (void)setType:(LLSPlateKeyBoardViewType)type {
    _type = type;
    switch (type) {
        case LLSPlateKeyBoardViewTypeChinese:
        {
            _keyboardView1.hidden = NO;
            _keyboardView2.hidden = YES;
        }
            break;
        case LLSPlateKeyBoardViewTypeLetter:
        {
            _keyboardView1.hidden = YES;
            _keyboardView2.hidden = NO;
        }
            break;
            
        default:
            break;
    }
}

@end
