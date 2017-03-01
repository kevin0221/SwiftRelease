//
//  CustomizeFieldsTableViewController.h
//  SwiftRelease
//
//  Created by beauty on 11/3/15.
//  Copyright © 2015 Beauty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomizeFieldsTableViewController : UITableViewController

@property (nonatomic, strong) NSArray* arrTitles;

@property (nonatomic, strong) NSMutableDictionary *dicCutomizeFields;


-(void)reset;
-(void)saveCurrentSettings;

@end
