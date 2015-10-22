//
//  CTSegControl.h
//  testSegControl
//
//  Created by trandy on 15/10/22.
//  Copyright © 2015年 ctquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTSegControl : UIControl

@property (nonatomic,strong)        UIColor     *textColor;
@property (nonatomic,strong)        UIFont      *textFont;
@property (nonatomic,strong)        UIColor     *segViewColor;
@property (nonatomic,assign)        BOOL        isAnimate;

@property (nonatomic,copy) void (^segControlWillSelected)(NSInteger index);
@property (nonatomic,copy) void (^segControlDidSelected)(NSInteger index);

- (instancetype)initWithTitle:(NSString *)firstTitle, ... NS_REQUIRES_NIL_TERMINATION;
- (instancetype)initWithView:(id)firstView, ... NS_REQUIRES_NIL_TERMINATION;
- (instancetype)initWithTitleArray:(NSArray *)titleArray;
- (instancetype)initWithViewArray:(NSArray *)viewArray;

@end
