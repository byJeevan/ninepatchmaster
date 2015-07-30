//
//  ViewController.m
//  ninepatchmaster
//
//  Created by jeevanRao7 on 30/07/15.
//

#import "ViewController.h"
#import "ninepatchmaster.h"

@interface ViewController ()<UIScrollViewDelegate> {
    
    UIImageView * imageView;
    UIScrollView * scrollView;
    UILabel * lableView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    imageView = [[UIImageView alloc] init];
    [self.view addSubview:imageView];
    
    scrollView = [[UIScrollView alloc] init];
    [imageView addSubview:scrollView];
    
    lableView = [[UILabel alloc] init];
    [scrollView addSubview:lableView];
    
    lableView.backgroundColor  = [UIColor lightGrayColor];
    
    scrollView.delegate = self;

}

-(void) viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    NSString * instructionText = @"Sample text for the nine patch image expandable area. Sample text for the nine patch image expandable area.Sample text for the nine patch image expandable area.Sample text for the nine patch image expandable area.Sample text for the nine patch image expandable area.Sample text for the nine patch image expandable area.Sample text for the nine patch image expandable area.Sample text for the nine patch image expandable area.Sample text for the nine patch image expandable area.Sample text for the nine patch image expandable area.Sample text for the nine patch image expandable area.Sample text for the nine patch image expandable area.Sample text for the nine patch image expandable area.Sample text for the nine patch image expandable area.Sample text for the nine patch image expandable area.Sample text for the nine patch image expandable area.Sample text for the nine patch image expandable area.Sample text for the nine patch image expandable area.Sample text for the nine patch image expandable area.Sample text for the nine patch image expandable area.Sample text for the nine patch image expandable area.";
    
    [ninepatchmaster applyNinePathImageForLabel:lableView scrollView:scrollView imageView:imageView availableHeight:300.0 instructionText:instructionText ninePatchImageName:@"common_paper_scroll.9" imageViewOrigin:30.0 forView:self.view];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

@end
