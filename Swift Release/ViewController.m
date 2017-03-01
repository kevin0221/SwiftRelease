//
//  ViewController.m
//  Release
//
//  Created by beauty on 10/26/15.
//  Copyright (c) 2015 Beauty. All rights reserved.
//

#import "ViewController.h"
#import "IntroViewController.h"
#import "MainViewController.h"
#import "AudioPlayer.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    
    self.pageController.dataSource = self;
    
    [[self.pageController view] setFrame:CGRectMake(0, 0, [[self view] bounds].size.width, [[self view] bounds].size.height + 37)];
    
    IntroViewController *initialViewController = [self viewControllerAtIndex:0];
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageController];
    [[self view] addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];
   
    
    [self.view bringSubviewToFront:self.pageControl];
    [self.view bringSubviewToFront:self.btnSkip];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IntroViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    IntroViewController *childViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"IntroViewController"];
    childViewController.index = index;
    
    return childViewController;
    
}


#pragma mark - UIPageViewDelegate

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(IntroViewController *)viewController index];
    
    [self.pageControl setCurrentPage:index];
    if (index == 0) {
        return nil;
    }
    
    [self.btnSkip setTitle:@"Skip >>" forState:UIControlStateNormal];
    
    if (index > 0) {
        // Decrease the index by 1 to return
        index -= 1;
    }
    
    
    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(IntroViewController *)viewController index];
    
    [self.pageControl setCurrentPage:index];
    [self.btnSkip setTitle:@"Skip >>" forState:UIControlStateNormal];
    
    // if last intro screen....
    if (index == 2)
    {
        [self.btnSkip setTitle:@"Start >>" forState:UIControlStateNormal];
        return nil;
    }
    
    
    if (index < 3) {
        index += 1;
    }
    
    return [self viewControllerAtIndex:index];
    
}


- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    
    return 3;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    
    return 0;
}


#pragma mark - 

- (IBAction)onSkip:(id)sender
{
    [AudioPlayer playButtonEffectSound];    
    
    NSString *fromSettings  = [[NSUserDefaults standardUserDefaults] objectForKey:@"fromSettings"];
    if (fromSettings == nil || [fromSettings isEqualToString:@"false"])
    {
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        MainViewController *mainViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
        
        UINavigationController *navcontroller = [[UINavigationController alloc] initWithRootViewController:mainViewController];
        appDelegate.window.rootViewController = navcontroller;
        
    }
    else if([fromSettings isEqualToString:@"true"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"false" forKey:@"fromSettings"];
        [self.navigationController popViewControllerAnimated:YES];
    }
        
}
@end
