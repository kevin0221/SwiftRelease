//
//  TermsViewController.h
//  SwiftRelease
//
//  Created by beauty on 11/2/15.
//  Copyright © 2015 Beauty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewReleaseViewController.h"


@interface TermsViewController : UIViewController

/////////////// All Fields //////////////////////////

// Photoshoot Info
@property (weak, nonatomic) IBOutlet UILabel *lblPhotoshoot_title;
@property (weak, nonatomic) IBOutlet UILabel *lblPhotoshoot_description;
@property (weak, nonatomic) IBOutlet UILabel *lblPhotoshoot_address;

// Photographer
@property (weak, nonatomic) IBOutlet UILabel *lblPhotographer;

// Witness
@property (weak, nonatomic) IBOutlet UILabel *lblWitness;

// Model Info
@property (weak, nonatomic) IBOutlet UIView *viewModelInfo;
@property (weak, nonatomic) IBOutlet UILabel *lblModel_name;
@property (weak, nonatomic) IBOutlet UILabel *lblModel_genderAndEthnicity;
@property (weak, nonatomic) IBOutlet UILabel *lblModel_streetAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblModel_address;
@property (weak, nonatomic) IBOutlet UILabel *lblModel_telephone;
@property (weak, nonatomic) IBOutlet UILabel *lblModel_email;

@property (weak, nonatomic) IBOutlet UIImageView *imgModel_photo;

// Property Info
@property (weak, nonatomic) IBOutlet UIView *viewPropertyInfo;
@property (weak, nonatomic) IBOutlet UILabel *lblProperty_description;
@property (weak, nonatomic) IBOutlet UILabel *lblProperty_streetAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblProperty_address;
@property (weak, nonatomic) IBOutlet UILabel *lblProperty_ownerName;
@property (weak, nonatomic) IBOutlet UILabel *lblProperty_ownerType;
@property (weak, nonatomic) IBOutlet UILabel *lblProperty_ownerTel;
@property (weak, nonatomic) IBOutlet UILabel *lblProperty_ownerEmail;

// Language bar
@property (weak, nonatomic) IBOutlet UIView *viewLanguageBar;
@property (weak, nonatomic) IBOutlet UIButton *btnLanguage;


// Terms of Agreement
@property (weak, nonatomic) IBOutlet UITextView *txtLegal;

//////////////////////////////////////////////////////

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;


- (IBAction)onLanguage:(id)sender;


@end
