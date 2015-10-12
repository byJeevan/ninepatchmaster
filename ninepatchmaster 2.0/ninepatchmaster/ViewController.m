//
//  ViewController.m
//  ninepatchmaster
//
//  Created by jeevanRao7 on 30/07/15.
//

#import "ViewController.h"
#import "ninepatchmaster.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
}

-(void) viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    NSString * text = @"abcd is goof dfdkfh ";
 
    UIImage * originalImage = [UIImage imageNamed:@"rectangle_box.9"];
    
    [ninepatchmaster applyNinePatchImage:originalImage withText:text forView:self.view];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
