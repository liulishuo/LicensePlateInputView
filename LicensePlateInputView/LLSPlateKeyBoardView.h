

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LLSPlateKeyBoardViewType) {
    LLSPlateKeyBoardViewTypeChinese,
    LLSPlateKeyBoardViewTypeLetter,
};

@class LLSPlateKeyBoardView;

@protocol LLSPlateKeyBoardViewDelegate <NSObject>

- (void)llsPlateKeyBoardView:(LLSPlateKeyBoardView *)view didSelectString:(NSString *)string;

- (void)llsPlateKeyBoardViewDidDelete:(LLSPlateKeyBoardView *)view;

@end

@interface LLSPlateKeyBoardView : UIView

@property (nonatomic, weak) id<LLSPlateKeyBoardViewDelegate> delegate;
@property (nonatomic, assign, readonly) BOOL isHidden;
@property (nonatomic, assign) LLSPlateKeyBoardViewType type;

- (void)show;
- (void)hide;

@end
