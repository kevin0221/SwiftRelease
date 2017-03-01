//
//  WitnessInfoTableViewController.h
//  SwiftRelease
//
//  Created by beauty on 11/2/15.
//  Copyright © 2015 Beauty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WitnessInfoTableViewController : UITableViewController <UITextFieldDelegate>
{
    UIDatePicker *datePicker;
}
// Input Fields....
@property (weak, nonatomic) IBOutlet UITextField *txtWitnessName;

// events

- (IBAction)onDownload:(id)sender;

@end
