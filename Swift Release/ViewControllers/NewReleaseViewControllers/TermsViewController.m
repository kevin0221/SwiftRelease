//
//  TermsViewController.m
//  SwiftRelease
//
//  Created by beauty on 11/2/15.
//  Copyright © 2015 Beauty. All rights reserved.
//

#import "TermsViewController.h"
#import "DBManager.h"

#import "ActionSheetStringPicker.h"
#import "AudioPlayer.h"

@interface TermsViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *languageBarHeight;
@property (weak, nonatomic) IBOutlet UIView *releaseTextView;

@end

@implementation TermsViewController

@synthesize scrollView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    switch (g_releaseType) {
        case ModelType:
            [self setValuesFromModel];
            break;
        case PropertyType:
            [self setValuesFromProperty];
            break;
        default:
            break;
    }
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    float imgWidth = (screenSize.width - 20) * 0.3f;
    self.imgModel_photo.layer.cornerRadius = imgWidth / 2.0f;
    self.imgModel_photo.clipsToBounds = YES;    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)viewDidLayoutSubviews
{
    float height = 476.0f + self.txtLegal.contentSize.height;
    NSString *strIsCustomRelease = [[NSUserDefaults standardUserDefaults] valueForKey:@"CustomRelease"];
    if ([strIsCustomRelease isEqualToString:@"yes"])
    {
        height -= 44.0f;
    }
        
    CGSize contentSize = CGSizeMake(scrollView.contentSize.width, height);
    self.contentHeight.constant = contentSize.height;
    [scrollView setContentSize:contentSize];
}

-(void)setValuesFromModel
{
    // set photoshoot info
    self.lblPhotoshoot_title.text = g_modelRelease.strPhotoshoot_title;
    self.lblPhotoshoot_description.text = g_modelRelease.strPhotoshoot_description;
    self.lblPhotoshoot_address.text = [self getLocationStringWithCity:g_modelRelease.strPhotoshoot_city state:g_modelRelease.strPhotoshoot_state country:g_modelRelease.strPhotoshoot_country];
    self.lblPhotographer.text = g_modelRelease.strPhotoshoot_photographer;
    
    // set model info
    [self.viewModelInfo setHidden:NO];
    [self.viewPropertyInfo setHidden:YES];
    
    self.imgModel_photo.image = [UIImage imageWithData:g_modelRelease.dataModel_photo];
    self.lblModel_name.text = g_modelRelease.strModel_name;
    self.lblModel_genderAndEthnicity.text = [NSString stringWithFormat:@"%@, %@", g_modelRelease.strModel_gender, g_modelRelease.strModel_ethnicity];
    self.lblModel_streetAddress.text = g_modelRelease.strModel_streetAddress;
    self.lblModel_address.text = [self getLocationStringWithCity:g_modelRelease.strModel_city state:g_modelRelease.strModel_state country:g_modelRelease.strModel_country];
    self.lblModel_telephone.text = g_modelRelease.strModel_phone;
    self.lblModel_email.text = g_modelRelease.strModel_email;
    
    // set witness info
    self.lblWitness.text = g_modelRelease.strWitness_name;
    
    NSString *strIsCustomRelease = [[NSUserDefaults standardUserDefaults] valueForKey:@"CustomRelease"];
    if ([strIsCustomRelease isEqualToString:@"yes"])
    {
        self.languageBarHeight.constant = 0.0f;
        NSString *customTextTitle = [[NSUserDefaults standardUserDefaults] valueForKey:@"CustomTextTitle"];
        NSString *customTextContent = [DBManager getCustomTextContentWithTitle:customTextTitle];
        self.txtLegal.text = customTextContent;
        g_modelRelease.strLegalText = customTextContent;
    }
    else
    {
        
        NSString *strLegalPath = [[NSBundle mainBundle] pathForResource:@"LegalText" ofType:@"plist"];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:strLegalPath];
        NSString *strText = [[dic objectForKey:@"ModelLegalText"] objectForKey:@"english"];
        self.txtLegal.text = strText;
        g_modelRelease.strLegalText = strText;
        
    }
}

-(void)setValuesFromProperty
{
    // set photoshoot info
    self.lblPhotoshoot_title.text = g_propertyRelease.strPhotoshoot_title;
    self.lblPhotoshoot_description.text = g_propertyRelease.strPhotoshoot_description;
    self.lblPhotoshoot_address.text = [self getLocationStringWithCity:g_propertyRelease.strPhotoshoot_city state:g_propertyRelease.strPhotoshoot_state country:g_propertyRelease.strPhotoshoot_country];
    self.lblPhotographer.text = g_propertyRelease.strPhotoshoot_photographer;
    
    // set Property info
    [self.viewPropertyInfo setHidden:NO];
    [self.viewModelInfo setHidden:YES];
    
    self.imgModel_photo.image = [UIImage imageWithData:g_propertyRelease.dataProperty_photo];
    self.lblProperty_description.text = g_propertyRelease.strProperty_description;
    self.lblProperty_streetAddress.text = g_propertyRelease.strProperty_address;
    self.lblProperty_address.text = [self getLocationStringWithCity:g_propertyRelease.strProperty_city state:g_propertyRelease.strProperty_state country:g_propertyRelease.strProperty_country];
    
    
    self.lblProperty_ownerName.text = g_propertyRelease.strProperty_Name;
    switch (g_propertyRelease.property_ownershipType) {
        case IndividualOwner:
            self.lblProperty_ownerType.text = @"Individual Owner";
            break;
        case CorporateOwner:
            self.lblProperty_ownerType.text = @"Corporate Owner";
            break;
        case AuthorizedRepresentative:
            self.lblProperty_ownerType.text = @"Authorized Representative";
            break;
        default:
            break;
    }
    
    self.lblProperty_ownerTel.text = g_propertyRelease.strProperty_phone;
    self.lblProperty_ownerEmail.text = g_propertyRelease.strProperty_email;
    
    // set witness info
    self.lblWitness.text = g_propertyRelease.strWitness_name;
    
    NSString *strIsCustomRelease = [[NSUserDefaults standardUserDefaults] valueForKey:@"CustomRelease"];
    if ([strIsCustomRelease isEqualToString:@"yes"])
    {
        self.languageBarHeight.constant = 0.0f;
        NSString *customTextTitle = [[NSUserDefaults standardUserDefaults] valueForKey:@"CustomTextTitle"];
        NSString *customTextContent = [DBManager getCustomTextContentWithTitle:customTextTitle];
        self.txtLegal.text = customTextContent;
        g_propertyRelease.strLegalText = customTextContent;
        
    }
    else
    {
        NSString *strLegalPath = [[NSBundle mainBundle] pathForResource:@"LegalText" ofType:@"plist"];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:strLegalPath];
        NSString *strText = [[dic objectForKey:@"PropertyLegalText"] objectForKey:@"english"];
        self.txtLegal.text = strText;
        g_propertyRelease.strLegalText = strText;
    }
}

-(NSString*)getLocationStringWithCity:(NSString*)city state:(NSString*)state country:(NSString*)country
{
    NSString *strLocation = city;
    NSString *strTmp = @"";
    if ([city isEqual:@""] || [state isEqual:@""])
    {
        if (![city isEqual:@""])
        {
            strTmp = city;
        }
        if (![state isEqual:@""]) {
            strTmp = state;
        }
        
        if (![strTmp isEqual:@""]) {
            strLocation = [NSString stringWithFormat:@"%@, %@", strTmp, country];
        }
    }
    else
        strLocation = [NSString stringWithFormat:@"%@, %@, %@", city, state, country];
    
    return strLocation;
}

- (IBAction)onLanguage:(id)sender
{
    [AudioPlayer playButtonEffectSound];
    
    NSArray *arrLanguages = @[@"English", @"Spanish", @"Russian", @"German", @"Italian", @"French", @"Finnish", @"Portuguese", @"Danish", @"Chinese", @"Korean"];
    
    [ActionSheetStringPicker showPickerWithTitle:@"Languages" rows:arrLanguages initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue)
    {
        NSString *strLanguage = arrLanguages[selectedIndex];
        [self.btnLanguage setTitle:strLanguage forState:UIControlStateNormal];
        
        NSString *strLegalPath = [[NSBundle mainBundle] pathForResource:@"LegalText" ofType:@"plist"];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:strLegalPath];
        self.txtLegal.text = [[dic objectForKey:@"ModelLegalText"] objectForKey:[strLanguage lowercaseString]];
        switch (g_releaseType) {
            case ModelType:
                g_modelRelease.strLegalText = [[dic objectForKey:@"ModelLegalText"] objectForKey:[strLanguage lowercaseString]];
                break;
            case PropertyType:
                g_propertyRelease.strLegalText = [[dic objectForKey:@"ModelLegalText"] objectForKey:[strLanguage lowercaseString]];
                break;
            default:
                break;
        }
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:self.btnLanguage];
}

@end
