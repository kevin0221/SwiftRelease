//
//  SignatureViewController.h
//  SwiftRelease
//
//  Created by beauty on 11/4/15.
//  Copyright © 2015 Beauty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewReleaseViewController.h"



@interface SignatureViewController : UIViewController

//@property (strong, nonatomic) NSString *fromWhich;
@property (strong, nonatomic) NSData *imgSignData;

@property (nonatomic, assign) CGPoint lastContactPoint1, lastContactPoint2, currentPoint;
@property (nonatomic, assign) CGRect imageFrame;
@property (nonatomic, assign) BOOL fingerMoved;

@property (nonatomic, strong) NSString *strSignerName;
@property (nonatomic, strong) NSString *strTitle;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIImageView *signImage;
@property (weak, nonatomic) IBOutlet UILabel *lblSignerName;
@property (weak, nonatomic) IBOutlet UILabel *lblCurrentDate;
@property (strong, nonatomic) id<SignDelegate> delegate;


- (IBAction)onBack:(id)sender;
- (IBAction)onSign:(id)sender;
- (IBAction)onClear:(id)sender;

@end
