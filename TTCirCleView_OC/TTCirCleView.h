//
//  TTCirCleView.h
//  TTCirCleView_OC
//
//  Created by tanson on 2017/1/25.
//  Copyright © 2017年 chatchat. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol  TTCirCleViewDelegate <NSObject>

@optional
-(void) cirCleViewPageViewTapAtIndex:(NSInteger)index;

@required
-(NSInteger) cirCleViewNumberOfPage;
-(void) imageViewWillShow:(UIImageView*)imageView atIndex:(NSInteger)index;

@end

@interface TTCirCleView : UIView

@property (nonatomic,weak) id<TTCirCleViewDelegate> delegate;
@property (nonatomic,strong) UIScrollView * contentScrollView;

-(instancetype)initWithFrame:(CGRect)frame delta:(NSInteger)delta delegate:(id<TTCirCleViewDelegate>)delegate;

@end

