//
//  ViewController.h
//  SwiftRelease
//
//  Created by beauty on 10/27/15.
//  Copyright (c) 2015 Beauty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ViewController : UIViewController <UIPageViewControllerDataSource>
{
    
}

@property (strong, nonatomic) UIPageViewController *pageController;

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (weak, nonatomic) IBOutlet UIButton *btnSkip;

- (IBAction)onSkip:(id)sender;
@end

