//
//  PopupViewController.m
//  Swift Release
//
//  Created by beauty on 12/11/15.
//  Copyright © 2015 pixels. All rights reserved.
//

#import "PopupViewController.h"
#import "NewReleaseViewController.h"
#import "AudioPlayer.h"

@interface PopupViewController ()

@end

@implementation PopupViewController

@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.btnPhotographer.layer.cornerRadius = 10.0f;
    self.btnModel.layer.cornerRadius = 10.0f;
    self.btnGallery.layer.cornerRadius = 10.0f;
    self.btnPrint.layer.cornerRadius = 10.0f;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setDocument:(ReaderDocument *)object
{
    document = object;
}

#pragma mark - button events

- (IBAction)onSendEmailToPhotographer:(id)sender
{
    [AudioPlayer playButtonEffectSound];
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"PhotographerInfo"];
    NSString *photographerEmail = [dic valueForKey:@"email"];
    
    switch (g_releaseType) {
        case ModelType:
            if (g_modelRelease.strPhotoshoot_photographerEmail != nil && ![g_modelRelease.strPhotoshoot_photographerEmail isEqualToString:@""]) {
                photographerEmail = g_modelRelease.strPhotoshoot_photographerEmail;
            }
            break;
        case PropertyType:
            if (g_propertyRelease.strPhotoshoot_photographerEmail != nil && ![g_propertyRelease.strPhotoshoot_photographerEmail isEqualToString:@""]) {
                photographerEmail = g_propertyRelease.strPhotoshoot_photographerEmail;
            }
            break;
        default:
            break;
    }
    
    [delegate tappedInEmailButton:sender withEmail:photographerEmail];
    [self.view removeFromSuperview];
}

- (IBAction)onSendEmailToModel:(id)sender
{
    NSLog(@"onSendEmailToModel");
    [AudioPlayer playButtonEffectSound];
    
    NSString *recipientEmail = nil;
    
    switch (g_releaseType) {
        case ModelType:
            recipientEmail = g_modelRelease.strModel_email;
            break;
        case PropertyType:
            recipientEmail = g_propertyRelease.strProperty_email;
            break;
        default:
            break;
    }
    [delegate tappedInEmailButton:sender withEmail:recipientEmail];
    [self.view removeFromSuperview];
}

- (IBAction)onSaveToGallery:(id)sender
{
    [AudioPlayer playButtonEffectSound];
    NSLog(@"onSaveToGallery");
    
    [delegate tappedInGalleryButton:sender];
    [self.view removeFromSuperview];
}

- (IBAction)onPrintRelease:(id)sender
{
    [AudioPlayer playButtonEffectSound];
    NSLog(@"onPrintRelease");
    [delegate tappedInPrintButton:sender];
    [self.view removeFromSuperview];
}

- (IBAction)onCancel:(id)sender
{
    [AudioPlayer playButtonEffectSound];
    [self.view removeFromSuperview];
}

@end
