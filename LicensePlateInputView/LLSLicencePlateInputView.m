//
//  VKLicencePlateInputView.m
//  Keyboard
//
//  Created by liulishuo on 2017/11/22.
//  Copyright © 2017年 liulishuo. All rights reserved.
//

#import "LLSLicencePlateInputView.h"
#import "LLSPlateKeyBoardView.h"
#import "LLSMacro.h"
#import <Masonry.h>

static const NSUInteger kItemCount = 8;

@interface LLSLicencePlateInputView ()<LLSPlateKeyBoardViewDelegate>

@property (nonatomic, strong) NSMutableArray<UILabel *> *labelArray;
@property (nonatomic, strong) NSMutableArray<UIView *> *lineArray;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) LLSPlateKeyBoardView *keyboardView;
@property (nonatomic, strong) UILabel *maskLabel;

@end

@implementation LLSLicencePlateInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configure];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configure];
    }
    return self;
}

- (void)configure {
    _labelArray = [NSMutableArray new];
    _lineArray = [NSMutableArray new];
    _textFont = [UIFont systemFontOfSize:20];
    _textColor = [UIColor blackColor];
    _generalLineColor = [UIColor grayColor];
    _indicatorLineColor = [UIColor redColor];
    _bottomLineGap = 5;
    _bottomLineHeight = 2;
    _bottomLineOffsetY = 0;
    _selectIndex = 0;
    
    [self setupUI];
}

- (void)setupUI{
    CGFloat width = self.frame.size.width / kItemCount;
    CGFloat height = self.frame.size.height;
    CGFloat lineGap = _bottomLineGap;
    
    for (NSInteger i = 0; i < kItemCount; i ++) {
        UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(width * i, 0, width, height)];
        textLabel.tag = i + 100;
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.font = _textFont;
        textLabel.textColor = _textColor;
        [self addSubview:textLabel];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(lineGap, textLabel.frame.size.height, textLabel.frame.size.width - 2 * lineGap, _bottomLineHeight)];
        lineView.backgroundColor = _generalLineColor;
        [_lineArray addObject:lineView];
        [textLabel addSubview:lineView];
        
        UITapGestureRecognizer *tapLabel = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapLabel:)];
        textLabel.userInteractionEnabled = YES;
        tapLabel.numberOfTapsRequired = 1;
        [textLabel addGestureRecognizer:tapLabel];
        [_labelArray addObject:textLabel];
        
        if (i == kItemCount - 1) {
            UILabel *maskLabel = [[UILabel alloc] initWithFrame:textLabel.bounds];
            maskLabel.text = @"+ 新\n能源";
            maskLabel.font = [UIFont systemFontOfSize:10];
            maskLabel.numberOfLines = 2;
            maskLabel.adjustsFontSizeToFitWidth = YES;
            maskLabel.textAlignment = NSTextAlignmentCenter;
            maskLabel.textColor = [UIColor grayColor];
            _maskLabel = maskLabel;
            [textLabel addSubview:maskLabel];
        }
    }
    
    [self addConstraints];
}

- (void)addConstraints {
    [_labelArray enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).offset(0);
                make.left.equalTo(self).offset(0);
                make.bottom.equalTo(self).offset(0);
            }];
        } else if (idx == kItemCount - 1){
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).offset(0);
                make.right.equalTo(self).offset(0);
                make.left.equalTo(_labelArray[idx - 1].mas_right).offset(0);
                make.bottom.equalTo(self).offset(0);
                make.width.equalTo(_labelArray[idx - 1]);
            }];
        } else {
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).offset(0);
                make.left.equalTo(_labelArray[idx - 1].mas_right).offset(0);
                make.bottom.equalTo(self).offset(0);
                make.width.equalTo(_labelArray[idx - 1]);
            }];
        }
        
        UIView *line = _lineArray[idx];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(obj).offset(_bottomLineOffsetY);
            make.left.equalTo(obj).offset(_bottomLineGap);
            make.right.equalTo(obj).offset(-_bottomLineGap);
            make.height.mas_equalTo(_bottomLineHeight);
        }];
    }];
    
    UILabel *label = _labelArray.lastObject;
    [_maskLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(label).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)resetUI {
    [_labelArray enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.font = _textFont;
        obj.textColor = _textColor;
        [_labelArray enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIView *line = _lineArray[idx];
            if (idx == _selectIndex) {
                line.backgroundColor = _indicatorLineColor;
            } else {
                line.backgroundColor = _generalLineColor;
            }
            [line mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(obj).offset(_bottomLineOffsetY);
                make.left.equalTo(obj).offset(_bottomLineGap);
                make.right.equalTo(obj).offset(-_bottomLineGap);
                make.height.mas_equalTo(_bottomLineHeight);
            }];
        }];
    }];
}

- (void)tapLabel:(UITapGestureRecognizer *)tap{
    NSInteger index = tap.view.tag - 100;
    if (index != 0 && index > _carNumStr.length) {
        return;
    }
    [self selectLabelWithIndex:index];
}

- (void)selectLabelWithIndex:(NSInteger)index{
    self.selectIndex = index;
    
    [self showKeyboard];
}

- (void)showSelectedIndexLineWithIndex:(NSInteger)index {
    [_lineArray enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == index) {
            obj.backgroundColor = _indicatorLineColor;
        } else {
            obj.backgroundColor = _generalLineColor;
        }
    }];
}

- (NSString *)getCarNum{
    UITextField *tf = [UITextField new];
    [tf resignFirstResponder];
    _carNumStr = @"";
    BOOL isHaveEmpety = NO;
    for (NSInteger i = 0; i < _labelArray.count; i ++) {
        UILabel *label = [_labelArray objectAtIndex:i];
        if ([self isBlankString:label.text]) {
            isHaveEmpety = YES;
        }
        _carNumStr = [_carNumStr stringByAppendingString:[self getStringByString:label.text]];
    }
    
    if ([_delegate respondsToSelector:@selector(llsLicencePlateInputView:changedText:)]) {
        [_delegate llsLicencePlateInputView:self changedText:_carNumStr];
    }
    
    if (_carNumStr.length == kItemCount) {
        _maskLabel.hidden = YES;
        [self hideKeyboard];
        self.selectIndex = -1;
    } else {
        _maskLabel.hidden = NO;
    }
    
    return _carNumStr;
}

-  (NSString *)getStringByString:(NSString*)str{
    if (str == nil || [str isKindOfClass:[NSNull class]]) {
        return @"";
    }else
        return str;
}

- (BOOL)checkAllLabelHaveValue{
    BOOL haveEmpty = NO;
    for (NSInteger i = 0; i < _labelArray.count; i ++) {
        UILabel *label = [_labelArray objectAtIndex:i];
        if ([self isBlankString:label.text]) {
            haveEmpty = YES;
            break;
        }
    }
    return haveEmpty;
}
- (BOOL) isBlankString:(NSString *)string {
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if ([string isEqualToString:@""] || string == nil || string == NULL || [string isEqualToString :@"null" ]|| [string isEqualToString:@"<null>"]) {
        return YES;
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    
    return NO;
}

#pragma mark - Event Response
#pragma mark - Delegate
- (void)llsPlateKeyBoardView:(LLSPlateKeyBoardView *)view didSelectString:(NSString *)string {
    UILabel *selectLabel = (UILabel *)_labelArray[self.selectIndex];
    selectLabel.text = string;
    if (self.selectIndex == kItemCount - 1) {
        BOOL isHaveEmpty =  [self checkAllLabelHaveValue];
        if (!isHaveEmpty) {
            
        }
    }else{
        self.selectIndex ++;
    }
    
    [self getCarNum];
}

- (void)llsPlateKeyBoardViewDidDelete:(LLSPlateKeyBoardView *)view {
    UILabel *selectLabel = _labelArray[self.selectIndex];
    if (selectLabel.text.length == 0) {
        if (self.selectIndex == 0) {
            self.selectIndex = 0;
        } else {
            self.selectIndex --;
        }
    } else {
        selectLabel.text = @"";
        for (NSInteger i = self.selectIndex; i < _labelArray.count; i++) {
            UILabel *l = _labelArray[i];
            l.text = @"";
        }
    }
    
    [self getCarNum];
}
#pragma mark - Methods
- (void)showKeyboard {
    if (!_keyboardView) {
        CGRect rect = _delegate.view.bounds;
        self.keyboardView = [[LLSPlateKeyBoardView alloc] initWithFrame:rect];
        self.keyboardView.delegate = self;
        [_delegate.view addSubview:self.keyboardView];
    }
    if ([_delegate respondsToSelector:@selector(llsLicencePlateInputViewDidBeginEditing:)]) {
        [_delegate llsLicencePlateInputViewDidBeginEditing:self];
    }
    [_keyboardView show];
    
    [self showSelectedIndexLineWithIndex:self.selectIndex];
}

- (void)hideKeyboard {
    if ([_delegate respondsToSelector:@selector(llsLicencePlateInputViewDidEndEditing:)]) {
        [_delegate llsLicencePlateInputViewDidEndEditing:self];
    }
    [_keyboardView hide];
}

- (BOOL)becomeFirstResponder {
    [self showKeyboard];
    return YES;
}

- (BOOL)resignFirstResponder {
    [self hideKeyboard];
    return YES;
}

#pragma mark - Setter and Getter
- (void)setCarNumber:(NSString *)carNumber {
    [carNumber enumerateSubstringsInRange:NSMakeRange(0, carNumber.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        NSInteger index = substringRange.location;
        UILabel *label = _labelArray[index];
        label.text = substring;
    }];
    
    self.selectIndex = carNumber.length;
    [self getCarNum];
}

- (void)setBottomLineGap:(CGFloat)bottomLineGap {
    _bottomLineGap = bottomLineGap;
    [self resetUI];
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    _selectIndex = selectIndex;
    [self showSelectedIndexLineWithIndex:self.selectIndex];
}

- (void)setTextFont:(UIFont *)font {
    _textFont = font;
    [self resetUI];
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    [self resetUI];
}

- (void)setGeneralLineColor:(UIColor *)generalLineColor {
    _generalLineColor = generalLineColor;
    [self resetUI];
}

- (void)setIndicatorLineColor:(UIColor *)indicatorLineColor {
    _indicatorLineColor = indicatorLineColor;
    [self resetUI];
}

- (void)setBottomLineOffsetY:(CGFloat)bottomLineOffsetY {
    _bottomLineOffsetY = bottomLineOffsetY;
    [self resetUI];
}

- (void)setBottomLineHeight:(CGFloat)bottomLineHeight {
    _bottomLineHeight = bottomLineHeight;
    [self resetUI];
}

@end
