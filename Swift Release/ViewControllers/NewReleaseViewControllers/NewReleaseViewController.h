//
//  NewReleaseViewController.h
//  SwiftRelease
//
//  Created by beauty on 10/29/15.
//  Copyright (c) 2015 Beauty. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ModelRelease.h"
#import "PropertyRelease.h"
#import "ReaderViewController.h"
#import "DataModel.h"

extern ReleaseType g_releaseType;
extern ModelRelease *g_modelRelease;
extern PropertyRelease *g_propertyRelease;
extern DataModel *g_mergeRelease;
extern BOOL g_isNew;

@protocol SignDelegate <NSObject>

- (void)didSign:(NSData *)sign date:(NSString*)strDate;
- (void)didSignCancel;

@end


@interface NewReleaseViewController : UIViewController <ReaderViewControllerDelegate, SignDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UILabel *lblStep;

@property (weak, nonatomic) IBOutlet UIButton *btnCancel;

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLayoutContraint;

- (IBAction)onCancel:(id)sender;
- (IBAction)onNext:(id)sender;
- (IBAction)onBack:(id)sender;


@end

