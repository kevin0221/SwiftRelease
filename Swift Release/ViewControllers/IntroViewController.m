//
//  IntroViewController.m
//  Release
//
//  Created by beauty on 10/26/15.
//  Copyright (c) 2015 Beauty. All rights reserved.
//

#import "IntroViewController.h"

@interface IntroViewController ()

@end

@implementation IntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imgIntro.image = [UIImage imageNamed:[NSString stringWithFormat:@"intro%ld.jpg", (long)self.index]];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
