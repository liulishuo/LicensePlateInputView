//
//  ViewController.m
//  LicensePlateInputView
//
//  Created by liulishuo on 2017/12/2.
//  Copyright © 2017年 liulishuo. All rights reserved.
//

#import "ViewController.h"
#import "LLSLicencePlateInputView.h"

@interface ViewController ()<LLSLicencePlateInputViewDelegate>

@property (weak, nonatomic) IBOutlet LLSLicencePlateInputView *inputView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _inputView.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:LLSLicencePlateInputViewKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:LLSLicencePlateInputViewKeyboardWillShowNotification object:nil];
}


- (void)viewWillAppear:(BOOL)animated {

}

- (void)keyboardShow:(NSNotification *)noti {
    UIView *keyboard = noti.object;
    UIView *contentView = [self.scrollView viewWithTag:100];
    UIView *targetView = _inputView;
    CGRect targetRect = [contentView convertRect:targetView.frame toView:self.scrollView];
    CGFloat pointY = targetRect.origin.y - self.scrollView.contentOffset.y;
    CGFloat offsetY = pointY + targetView.frame.size.height - (self.view.frame.size.height - keyboard.frame.size.height);
    if (offsetY > 0) {
        CGPoint contentOffset = self.scrollView.contentOffset;
        contentOffset.y += offsetY;
        CGFloat padding = 20;
        contentOffset.y += padding;
        [self.scrollView setContentOffset:contentOffset animated:YES];
    }
}

- (void)keyboardHide:(NSNotification *)noti {
    
}

- (void)llsLicencePlateInputView:(LLSLicencePlateInputView *)view changedText:(NSString *)text {
    NSLog(@"%@",text);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickToLineUp:(id)sender {
    _inputView.bottomLineOffsetY --;
}

- (IBAction)clickToLineDown:(id)sender {
    _inputView.bottomLineOffsetY ++;
}

- (IBAction)clickToChangeColor:(id)sender {
    _inputView.textColor = [UIColor blueColor];
    _inputView.indicatorLineColor = [UIColor yellowColor];
    _inputView.generalLineColor = [UIColor blackColor];
}
- (IBAction)clickToGapBigger:(id)sender {
    _inputView.bottomLineGap ++;
}

- (IBAction)clickToGapSmaller:(id)sender {
    _inputView.bottomLineGap --;
}

@end
