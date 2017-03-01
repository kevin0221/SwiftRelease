//
//  SettingsMainTableViewController.h
//  SwiftRelease
//
//  Created by beauty on 11/3/15.
//  Copyright © 2015 Beauty. All rights reserved.
//

#import <UIKit/UIKit.h>


extern int g_settingIndex;

@interface SettingsMainTableViewController : UITableViewController

@property (strong, nonatomic) NSArray *arrLanguages;


@property (weak, nonatomic) IBOutlet UILabel *lblLanguage;
@property (weak, nonatomic) IBOutlet UILabel *lblReleaseType;
@property (weak, nonatomic) IBOutlet UILabel *lblDocumentType;



@end
