//
//  TTCirCleView.m
//  TTCirCleView_OC
//
//  Created by tanson on 2017/1/25.
//  Copyright © 2017年 chatchat. All rights reserved.
//

#import "TTCirCleView.h"

@interface TTCirCleView ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIImageView * firstPageView;
@property (nonatomic,strong) UIImageView * secondPageView;
@property (nonatomic,strong) UIImageView * thirdPageView;
@property (nonatomic,strong) UILabel * pageLab;
@property (nonatomic,strong) dispatch_source_t timer;

@property (nonatomic,assign) NSInteger preIndex;
@property (nonatomic,assign) NSInteger curIndex;
@property (nonatomic,assign) NSInteger nextIndex;
@property (nonatomic,assign) NSInteger pageCount;

@end

@implementation TTCirCleView{
    NSInteger _delta;
}

-(instancetype)initWithFrame:(CGRect)frame delta:(NSInteger)delta delegate:(id<TTCirCleViewDelegate>)delegate {
    if([super initWithFrame:frame]){
        _delta = delta;
        self.delegate = delegate;
        [self addSubview:self.contentScrollView];
        [self.contentScrollView addSubview:self.firstPageView];
        [self.contentScrollView addSubview:self.secondPageView];
        [self.contentScrollView addSubview:self.thirdPageView];
        [self addSubview:self.pageLab];
        [self reloadData];
        [self startTimer];
    }
    return self;
}

-(UIScrollView *)contentScrollView{
    if(!_contentScrollView){
        _contentScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _contentScrollView.delegate = self;
        _contentScrollView.bounces = false;
        _contentScrollView.pagingEnabled = true;
        _contentScrollView.backgroundColor = [UIColor blueColor];
        _contentScrollView.showsHorizontalScrollIndicator = false;
    }
    return _contentScrollView;
}

-(UIImageView *)firstPageView{
    if(!_firstPageView){
        _firstPageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _firstPageView.userInteractionEnabled = true;
        _firstPageView.clipsToBounds = true;
        _firstPageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _firstPageView;
}
-(UIImageView *)secondPageView{
    if(!_secondPageView){
        CGRect frame = self.bounds;
        frame.origin.x = frame.size.width;
        _secondPageView = [[UIImageView alloc] initWithFrame:frame];
        _secondPageView.userInteractionEnabled = true;
        _secondPageView.clipsToBounds = true;
        _secondPageView.contentMode = UIViewContentModeScaleAspectFill;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pageViewTapAction)];
        [_secondPageView addGestureRecognizer:tap];
    }
    return _secondPageView;
}
-(UIImageView *)thirdPageView{
    if(!_thirdPageView){
        CGRect frame = self.bounds;
        frame.origin.x = frame.size.width*2;
        _thirdPageView = [[UIImageView alloc] initWithFrame:frame];
        _thirdPageView.userInteractionEnabled = true;
        _thirdPageView.clipsToBounds = true;
        _thirdPageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _thirdPageView;
}

-(UILabel *)pageLab{
    if(!_pageLab){
        _pageLab = [UILabel new];
        _pageLab.textColor = [UIColor whiteColor];
    }
    return _pageLab;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGSize size = self.bounds.size;
    [self.pageLab sizeToFit];
    self.pageLab.layer.anchorPoint = CGPointMake(1, 1);
    self.pageLab.layer.position = CGPointMake(size.width - 20, size.height - 10);
}

-(void)pageViewTapAction{
    if(self.delegate && [self.delegate respondsToSelector:@selector(cirCleViewPageViewTapAtIndex:)]){
        [self.delegate cirCleViewPageViewTapAtIndex:self.curIndex];
    }
}

-(NSInteger)pageCount{
    return [self.delegate cirCleViewNumberOfPage];
}

-(NSInteger)preIndex{
    NSInteger p = self.curIndex-1;
    return p >= 0? p:self.pageCount-1;
}

-(NSInteger)nextIndex{
    NSInteger p = self.curIndex+1;
    return p < self.pageCount ? p:0;
}

-(void) reloadData{
    
    if(!self.delegate)return;
    NSInteger count = self.pageCount;
    if(count <= 0)return;
    
    // 只有一个页面时
    if (count <= 1) {
        self.contentScrollView.contentSize = self.bounds.size;
        [self.delegate imageViewWillShow:self.firstPageView atIndex:self.curIndex];
        return;
    }
    
    self.contentScrollView.contentSize = CGSizeMake(self.bounds.size.width*3, 0);
    self.contentScrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
    [self.delegate imageViewWillShow:self.firstPageView atIndex:self.preIndex];
    [self.delegate imageViewWillShow:self.secondPageView atIndex:self.curIndex];
    [self.delegate imageViewWillShow:self.thirdPageView atIndex:self.nextIndex];
    
    NSString * pageStr = [NSString stringWithFormat:@"%ld/%ld",(long)(self.curIndex+1),(long)self.pageCount];
    self.pageLab.text = pageStr;
    [self.pageLab sizeToFit];
}

-(void)startTimer{
    if(self.timer)return;
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    __weak typeof(self) wSelf = self;
    
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, _delta * NSEC_PER_SEC);
    uint64_t interval = _delta * NSEC_PER_SEC;
    dispatch_source_set_timer(self.timer, start, interval, 0);
    dispatch_source_set_event_handler(self.timer, ^{
        [wSelf.contentScrollView setContentOffset:CGPointMake(wSelf.bounds.size.width*2, 0) animated:YES];
    });
    dispatch_resume(self.timer);
}
-(void)stopTimer{
    if(!self.timer)return;
    dispatch_cancel(self.timer);
    self.timer = nil;
}

#pragma mark- scrollView delegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self stopTimer];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate) {
        [self scrollViewDidEndDecelerating:scrollView];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat offset = scrollView.contentOffset.x;
    if (offset == 0) {
        self.curIndex = self.preIndex;
    }else if (offset >= self.frame.size.width*2) {
        self.curIndex = self.nextIndex;
    }else{
        return;
    }
    [self reloadData];
    [self startTimer];
}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    self.curIndex = self.nextIndex;
    [self reloadData];
}

@end
