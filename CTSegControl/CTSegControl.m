//
//  CTSegControl.m
//  testSegControl
//
//  Created by trandy on 15/10/22.
//  Copyright © 2015年 ctquan. All rights reserved.
//

#import "CTSegControl.h"

@interface CTSegControl()

@property (nonatomic,copy)      NSArray     *dataArray;
@property (nonatomic,assign)    CGFloat     itemWidth;
@property (nonatomic,strong)    CALayer     *selectLayer;
@property (nonatomic,assign)    NSInteger   selectIndex;

@end

@implementation CTSegControl

- (instancetype )initWithTitle:(NSString *)firstTitle, ... NS_REQUIRES_NIL_TERMINATION;
{
    self = [super init];
    if (self) {
        
        va_list args;
        va_start(args, firstTitle);
        
        NSMutableArray* tmpArray = [@[] mutableCopy];
        for(NSString *title = firstTitle; title != nil; title = va_arg(args,NSString *))
        {
            [tmpArray addObject:title];
        }
        va_end(args);
        
        [self initData:tmpArray];
    }
    return self;
}

- (instancetype)initWithView:(id)firstView, ... NS_REQUIRES_NIL_TERMINATION;
{
    self = [super init];
    if (self) {
        va_list args;
        va_start(args, firstView);
        
        NSMutableArray* tmpArray = [@[] mutableCopy];
        for(UIView *title = firstView; title != nil; title = va_arg(args,UIView *))
        {
            [tmpArray addObject:title];
        }
        va_end(args);
        
        [self initData:tmpArray];
    }
    return self;
}

- (instancetype)initWithTitleArray:(NSArray *)titleArray
{
    self = [super init];
    if (self) {
        [self initData:titleArray];
    }
    return self;
}

- (instancetype)initWithViewArray:(NSArray *)viewArray
{
    self = [super init];
    if (self) {
        [self initData:viewArray];
    }
    return self;
}

- (void)initData:(NSArray *)array
{
    self.dataArray = [array copy];
    
    //default text color
    self.textColor = [UIColor grayColor];
    self.backgroundColor = [UIColor clearColor];
    self.segViewColor = [UIColor blueColor];
    self.selectLayer = [CALayer layer];
    self.selectIndex = 0;
    self.isAnimate = YES;
}


- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (self.dataArray) {
        self.itemWidth = frame.size.width / [self.dataArray count];
    }
    [self setNeedsDisplay];
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    if (self.dataArray) {
        self.itemWidth = bounds.size.width / [self.dataArray count];
    }
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [self.backgroundColor set];
    
    [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isKindOfClass:[NSString class]]) {
            CGFloat x = self.itemWidth * idx;
            CGFloat y = self.frame.size.height/2 - self.textFont.pointSize/2;
            CGRect rect = {x, y, self.itemWidth, self.textFont.pointSize};
            NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            style.alignment = NSTextAlignmentCenter;
            
            [obj drawInRect:rect withAttributes:@{
                                                  NSForegroundColorAttributeName:self.textColor,
                                                  NSParagraphStyleAttributeName:style,
                                                  NSBackgroundColorAttributeName:[UIColor clearColor],
                                                  NSFontAttributeName:self.textFont
                                                  }];
        }
        if ([obj isKindOfClass:[UIView class]]){
            UIView* view = (UIView *)obj;
            
            CGFloat x = self.itemWidth * idx  + self.itemWidth/2 - view.frame.size.width/2;
            CGFloat y = self.frame.size.height/2 - view.frame.size.height/2;
            CGRect rect = {x,y,view.frame.size.width,view.frame.size.height};
            view.layer.frame = rect;
            [self.layer addSublayer:view.layer];
        }
        
        
    }];
    
    self.selectLayer.frame = [self frameForSelectLayer];
    self.selectLayer.backgroundColor = self.segViewColor.CGColor;
    [self.layer addSublayer:self.selectLayer];
}

- (CGRect )frameForSelectLayer
{
    CGRect layerRect = {self.selectIndex*self.itemWidth,self.frame.size.height - 4,self.itemWidth,4};
    return layerRect;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    
    if (CGRectContainsPoint(self.bounds, touchLocation)) {
        NSInteger segment = touchLocation.x / self.itemWidth;
        if (segment != self.selectIndex) {
            [self setSelectedIndex:segment animated:self.isAnimate];
        }
    }
}

- (void)setSelectedIndex:(NSInteger) index animated:(BOOL)isAnimated
{
    self.selectLayer.actions = nil;
    
    if (isAnimated) {
        [CATransaction begin];
        [CATransaction setAnimationDuration:0.15];
        [CATransaction setCompletionBlock:^{
            if (self.segControlDidSelected) {
                self.segControlDidSelected(index);
            }
        }];
        
        if (self.segControlWillSelected) {
            self.segControlWillSelected(index);
        }
        self.selectIndex = index;
        self.selectLayer.frame = [self frameForSelectLayer];
        [CATransaction setDisableActions:NO];
        [CATransaction commit];
    }else
    {
        NSMutableDictionary *newActions = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNull null], @"position", [NSNull null], @"bounds", nil];
        self.selectLayer.actions = newActions;
        
        self.selectIndex = index;
        self.selectLayer.frame = [self frameForSelectLayer];
        
        if (self.segControlWillSelected) {
            self.segControlWillSelected(index);
        }
        
        if (self.segControlDidSelected) {
            self.segControlDidSelected(index);
        }
    }
    
    
}

@end
