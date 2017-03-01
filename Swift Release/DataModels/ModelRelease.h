//
//  ModelRelease.h
//  SwiftRelease
//
//  Created by beauty on 11/4/15.
//  Copyright © 2015 Beauty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataRelease.h"
#import "Photoshoot.h"
#import "Model.h"

#define str_Photographer @"Photographer"
#define str_ShootTitle @"Shoot Title"
#define str_ShootDescription @"Shoot Description"
#define str_Date @"Date"
#define str_ModelName @"Model Name"
#define str_DateOfBirth @"Date of Birth"
#define str_Gender @"Gender"
#define str_Ethnicity @"Ethnicity"
#define str_StreetAddress @"Street Address"
#define str_City @"City"
#define str_State @"State"
#define str_Country @"Country"
#define str_Email @"Email"
#define str_Phone @"Phone"
#define str_Witness @"Witness"

@interface ModelRelease : DataRelease

    // Model's Personal Information
    @property(nonatomic, strong) NSData *dataModel_photo;
    @property(nonatomic, strong) NSString *strModel_name;
    @property(nonatomic, strong) NSString *strModel_birth;
    @property(nonatomic, strong) NSString *strModel_gender;
    @property(nonatomic, strong) NSString *strModel_ethnicity;

    @property(nonatomic, strong) NSString *strModel_parentName;

    @property(nonatomic, strong) NSString *strModel_streetAddress;
    @property(nonatomic, strong) NSString *strModel_city;
    @property(nonatomic, strong) NSString *strModel_state;
    @property(nonatomic, strong) NSString *strModel_country;
    @property(nonatomic, strong) NSString *strModel_zipCode;
    
    @property(nonatomic, strong) NSString *strModel_email;
    @property(nonatomic, strong) NSString *strModel_phone;
    
    // Model Signature imagedata
    @property(nonatomic, strong) NSData *imgModel_signatureData;
    @property(nonatomic, strong) NSString *strModel_signDate;

    @property(nonatomic, strong) NSString *strFileName;


-(instancetype) init;

-(void)setPhotoshoot:(Photoshoot*)photoshoot;

-(void)setPhotoshootPhotographer:(NSString*)photograhper Title:(NSString*)title Description:(NSString*)description Date:(NSString*)date City:(NSString*)city State:(NSString*)state Country:(NSString*)country;

-(void)setModel:(Model*)model;
-(void)setModelPhoto:(NSData*)photo Name:(NSString*)name Birthday:(NSString*)birth Gender:(NSString*)gender Ethnicity:(NSString*)ethnicity ParentName:(NSString*)parentName;
-(void)setModelStreetAddress:(NSString*)streetAddress City:(NSString*)city State:(NSString*)state Country:(NSString*)country Zipcode:(NSString*)zipCode Email:(NSString*)email Phone:(NSString*)phone;
-(void)setWitnessInfoName:(NSString*)name;

-(void)setModelSignImgData:(NSData*)imgData withDate:(NSString*)strDate;



@end
