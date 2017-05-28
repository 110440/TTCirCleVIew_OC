//
//  ViewController.m
//  TTCirCleView_OC
//
//  Created by tanson on 2017/1/25.
//  Copyright © 2017年 chatchat. All rights reserved.
//

#import "ViewController.h"
#import "TTCirCleView.h"

@interface ViewController ()<TTCirCleViewDelegate>

@property (nonatomic,strong) TTCirCleView * circleView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.circleView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(TTCirCleView *)circleView{
    if(!_circleView){
        CGRect frame = CGRectMake(0, 0, self.view.bounds.size.width, 150);
        _circleView = [[TTCirCleView alloc] initWithFrame:frame delta:3 delegate:self];
    }
    return _circleView;
}

-(NSInteger)cirCleViewNumberOfPage{
    return 4;
}

-(void)imageViewWillShow:(UIImageView *)imageView atIndex:(NSInteger)index{
    NSArray * imgs = @[@"tt1.jpg",@"tt2.jpg",@"tt3.jpg",@"tt4.jpg"];
    imageView.image = [UIImage imageNamed:imgs[index]];
}

-(void) cirCleViewPageViewTapAtIndex:(NSInteger)index{
    
}
@end
