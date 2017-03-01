//
//  ShootInfoViewController.h
//  SwiftRelease
//
//  Created by beauty on 10/29/15.
//  Copyright (c) 2015 Beauty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface ShootInfoViewController : UITableViewController <UITextFieldDelegate, CLLocationManagerDelegate>
{
    UIDatePicker *datePicker;
    
    CLLocationManager *locationManager;
    
    CLLocation *currentLocation;
    
    NSString *m_strLatitude, *m_strLongitude, *m_strCity, *m_strState, *m_strCountry;
    
    BOOL m_bAvailableGPS;
}

// input fields....
@property (weak, nonatomic) IBOutlet UITextField *txtPhotographerName;
@property (weak, nonatomic) IBOutlet UITextField *txtTitle;
@property (weak, nonatomic) IBOutlet UITextField *txtDescription;
@property (weak, nonatomic) IBOutlet UIButton *btnDate;

@property (weak, nonatomic) IBOutlet UITextField *txtCity;
@property (weak, nonatomic) IBOutlet UITextField *txtState;
@property (weak, nonatomic) IBOutlet UITextField *txtCountry;


// events
- (IBAction)onDownload:(id)sender;
- (IBAction)onMap:(id)sender;

- (IBAction)onDatePicker:(id)sender;

-(BOOL)checkInputDatas;


@end
