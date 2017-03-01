//
//  ReleaseTypeViewController.h
//  Swift Release
//
//  Created by beauty on 11/9/15.
//  Copyright © 2015 pixels. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReleaseTypeViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *m_arrTitles;
@property (nonatomic, strong) NSArray *m_arrCustomTexts;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomMargin;


@property (weak, nonatomic) IBOutlet UITextView *txtCustomText;

@property (weak, nonatomic) IBOutlet UIButton *btnReleaseType;
@property (weak, nonatomic) IBOutlet UITextField *txtCustomTextTitle;

/*
- (IBAction)onChange:(id)sender;

- (IBAction)onEdit:(id)sender;
- (IBAction)onSave:(id)sender;
*/
- (IBAction)onTitle:(id)sender;

- (IBAction)onDelete:(id)sender;
- (IBAction)onAdd:(id)sender;
- (void) onSave;

@end
