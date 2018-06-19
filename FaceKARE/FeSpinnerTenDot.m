//
//  FeSpinnerTenDot.m
//  FeSpinner
//
//  Created by Nghia Tran on 11/29/13.
//  Copyright (c) 2013 fe. All rights reserved.
//

#import "FeSpinnerTenDot.h"
#import "FXBlurView.h"
#import "FeTenDot.h"
#define kMaxTenDot 10
#define kPagingLabel 30


@interface FeSpinnerTenDot ()
{
    id targetForExecuting;
    SEL methodForExecuting;
    id objectForExecuting;
    dispatch_block_t completionBlock;
}
// Blur View
@property (strong, nonatomic) FXBlurView *backgroundBlur;

// Background Static for Blur View
@property (strong, nonatomic) UIView *backgroundStatic;

// Arr of dot
@property (strong, nonatomic) NSMutableArray *arrDot;

// Container View
@property (weak, nonatomic) UIView *containerView;

// Timer
@property (strong, nonatomic) NSTimer *timer;

// Label
@property (strong, nonatomic) UILabel *label;

// BOOL
@property (assign, nonatomic) BOOL isShouldBlur;
@property (assign, nonatomic) BOOL isAnimating;

//****************************
// Common init
-(void) commonInit;
-(void) initBackgroundWithBlur:(BOOL) blur;
-(void) initDot;

@end
@implementation FeSpinnerTenDot

- (id)initWithView:(UIView *)view withBlur:(BOOL)blur
{
    // CHeck
    if (view.bounds.size.height <= 100)
    {
        NSAssert(NO, @"Container View's height shouldn't less than 100");
    }
    
    self = [super init];
    if (self)
    {
        _containerView = view;
        _isShouldBlur = blur;
        _arrDot = [[NSMutableArray alloc] initWithCapacity:10];
        
        // init common
        [self commonInit];
        
        // BOOl
        _isAnimating = NO;
        self.hidden = YES;
        self.alpha = 0;

    }
    return self;
}

#pragma mark Common Init
- (void)commonInit
{
    // init frame as bound container
    self.frame = _containerView.bounds;
    
    // init Background
    [self initBackgroundWithBlur:_isShouldBlur];
    
    // init Ten Dot
    [self initDot];
    
}
- (void)initBackgroundWithBlur:(BOOL)blur
{
    // init Background for Blur View
    if (_isShouldBlur)
    {
        _backgroundBlur = [[FXBlurView alloc] initWithFrame:_containerView.bounds];
        _backgroundBlur.blurRadius = 40;
        _backgroundBlur.tintColor = [UIColor redColor];
        _backgroundBlur.dynamic = NO;
        [_backgroundBlur.layer displayIfNeeded];
        
        // Hide background
        _backgroundBlur.hidden = YES;
        
    }
    else
    {
        _backgroundStatic = [[UIView alloc] initWithFrame:_containerView.bounds];
        _backgroundStatic.backgroundColor = [UIColor blackColor];
        _backgroundStatic.alpha = 0.7f;
    }

}
- (void)initDot
{
    CGPoint center = self.center;
    
    // init center dot
    UIView *centerDot = [[UIView alloc] initWithFrame:CGRectMake(center.x, center.y, 20, 20)];
    centerDot.clipsToBounds = YES;
    centerDot.layer.cornerRadius = centerDot.bounds.size.height /2;
    centerDot.backgroundColor = [UIColor whiteColor];
    centerDot.center = center;
    
    [self addSubview:centerDot];
    
    // init 10 dot
    for (NSInteger i = 0 ; i < kMaxTenDot; i++)
    {
        FeTenDot *dot = [[FeTenDot alloc] initDotAtMainView:self atIndex:i];
        [_arrDot addObject:dot];
        
        [self addSubview: dot];
        
    }
}

#pragma mark Action Animate
- (void)show
{
    if (_isAnimating)
        return;
    
    //Set hidden
    self.hidden = NO;
    self.alpha = 0;
    
    if (_isShouldBlur)
    {
        _backgroundBlur.alpha = 0;
        _backgroundBlur.hidden = NO;
        [_containerView insertSubview:_backgroundBlur belowSubview:self];
    }
    else
    {
        [self insertSubview:_backgroundStatic atIndex:0];
    }
    
    // Call Delegate
    if ([_delegate respondsToSelector:@selector(FeSpinnerTenDotWillShow:)])
    {
        [_delegate FeSpinnerTenDotWillShow:self];
    }
    
    [UIView animateWithDuration:0.5f delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^
    {
                         self.alpha = 1;
        
        if (self->_isShouldBlur)
        {
            self->_backgroundBlur.alpha = 1;
        }
                     } completion:^(BOOL finished)
    {
        self->_isAnimating = YES;
        // Call Delegate
        if ([self->_delegate respondsToSelector:@selector(FeSpinnerTenDotDidShow:)])
        {
            [self->_delegate FeSpinnerTenDotDidShow:self];
        }
        CGFloat delay = 0;
        for (NSInteger i = 0 ; i < kMaxTenDot ; i++)
        {
            FeTenDot *dot = self->_arrDot[i];
            [dot performSelector:@selector(start) withObject:nil afterDelay:delay];
            
            delay += 0.1f;
        }
    }];
    
}

- (void)showWhileExecutingSelector:(SEL)selector onTarget:(id)target withObject:(id)object completion:(dispatch_block_t)completion
{
    // Check Selector is responded
    if ([target respondsToSelector:selector])
    {
        methodForExecuting = selector;
        targetForExecuting = target;
        objectForExecuting = object;
        completionBlock = completion;
        [self show];
    }
}


@end
