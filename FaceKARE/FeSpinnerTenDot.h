//
//  FeSpinnerTenDot.h
//  FeSpinner
//
//  Created by Nghia Tran on 11/29/13.
//  Copyright (c) 2013 fe. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FeSpinnerTenDotDelegate;

@interface FeSpinnerTenDot : UIView

// Init Fe Spinner View Ten Dot
-(id) initWithView:(UIView *) view withBlur:(BOOL) blur;

// Delegate
@property (weak, nonatomic) id<FeSpinnerTenDotDelegate> delegate;

-(void) show;

-(void) showWhileExecutingSelector:(SEL)selector onTarget:(id)target withObject:(id)object completion:(dispatch_block_t) completion;

@end

@protocol FeSpinnerTenDotDelegate <NSObject>
@optional
-(void) FeSpinnerTenDotWillShow:(FeSpinnerTenDot *) sender;
-(void) FeSpinnerTenDotDidShow:(FeSpinnerTenDot *) sender;

@end
