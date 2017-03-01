//
//  PropertyInformationTableViewController.h
//  SwiftRelease
//
//  Created by beauty on 11/4/15.
//  Copyright © 2015 Beauty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface PropertyInformationTableViewController : UITableViewController <UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    
    NSString *m_strLatitude, *m_strLongitude, *m_strStreetAddress, *m_strCity, *m_strState, *m_strCountry, *m_strPostalCode;
    
    BOOL m_bEnableLocation;
}

// Outlets of Input Fields..
@property (weak, nonatomic) IBOutlet UIImageView *imgPhoto;
@property (weak, nonatomic) IBOutlet UITextField *txtDescription;

@property (weak, nonatomic) IBOutlet UITextField *txtAddress;
@property (weak, nonatomic) IBOutlet UITextField *txtCity;
@property (weak, nonatomic) IBOutlet UITextField *txtState;
@property (weak, nonatomic) IBOutlet UITextField *txtCountry;
@property (weak, nonatomic) IBOutlet UITextField *txtZipCode;

@property (weak, nonatomic) IBOutlet UIButton *btnCamera;

- (IBAction)onCamera:(id)sender;
- (IBAction)onLocation:(id)sender;
- (IBAction)onDownload:(id)sender;




@end
