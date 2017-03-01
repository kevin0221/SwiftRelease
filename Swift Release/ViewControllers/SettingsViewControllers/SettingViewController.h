//
//  SettingViewController.h
//  SwiftRelease
//
//  Created by beauty on 10/29/15.
//  Copyright (c) 2015 Beauty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingNavigationController.h"

@interface SettingViewController : UIViewController

@property(nonatomic, strong) SettingNavigationController *settingNavigationController;

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnRefresh;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;


- (IBAction)onBack:(id)sender;
- (IBAction)onRefresh:(id)sender;
- (IBAction)onSave:(id)sender;

@end
