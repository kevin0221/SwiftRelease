//
//  MainViewController.h
//  Release
//
//  Created by beauty on 10/27/15.
//  Copyright (c) 2015 Beauty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ReaderViewController.h"
#import "DataModel.h"


typedef enum{
    NoneStyle,
    MergeStyle,
}ActionStyle;

@interface MainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIAlertViewDelegate, ReaderViewControllerDelegate>
{
    ActionStyle m_actionStyle;
    
}


@property (nonatomic, strong) NSMutableArray *arrDataModels;
@property (nonatomic, strong) NSMutableArray *arrFilterModels;

@property (nonatomic, strong) DataModel *selectedDataModel;

@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UITextField *txtSearch;

@property (weak, nonatomic) IBOutlet UIButton *btnHelpView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *dialog;

@property (weak, nonatomic) IBOutlet UIButton *btnDate;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintSearchHeight;

- (IBAction)onDate:(id)sender;
- (IBAction)onSearch:(id)sender;
- (IBAction)onHelp:(id)sender;
- (IBAction)onHelpScreen:(id)sender;


- (IBAction)onNew:(id)sender;

- (IBAction)onNewModel:(id)sender;
- (IBAction)onNewProperty:(id)sender;
- (IBAction)onScreenTouch:(id)sender;
- (IBAction)onClose:(id)sender;

@end
