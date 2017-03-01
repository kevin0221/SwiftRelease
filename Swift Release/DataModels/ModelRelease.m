//
//  ModelRelease.m
//  SwiftRelease
//
//  Created by beauty on 11/4/15.
//  Copyright © 2015 Beauty. All rights reserved.
//

#import "ModelRelease.h"

@implementation ModelRelease

-(instancetype) init
{
    self = [super init];
    
    self.strLegalText = @"";
    
    // Photoshoot Information
    self.strPhotoshoot_photographer = @"";
    self.strPhotoshoot_title = @"";
    self.strPhotoshoot_description = @"";
    self.strPhotoshoot_date = @"";
    
    self.strPhotoshoot_city = @"";
    self.strPhotoshoot_state = @"";
    self.strPhotoshoot_country = @"";
    
    // Witness Information
    self.strWitness_name = @"";
    self.imgWitness_signature = [[NSData alloc] init];
    self.strWitness_signDate = @"";
    
    // Model's Personal Information
    self.dataModel_photo = [[NSData alloc] init];
    self.strModel_name = @"";
    self.strModel_birth = @"";
    self.strModel_gender = @"";
    self.strModel_ethnicity = @"";
    
    self.strModel_parentName = @"";
    
    self.strModel_streetAddress = @"";
    self.strModel_city = @"";
    self.strModel_state = @"";
    self.strModel_country = @"";
    self.strModel_zipCode = @"";
    
    self.strModel_email = @"";
    self.strModel_phone = @"";
    
    return self;
}

#pragma mark - photoshoot info

-(void)setPhotoshoot:(Photoshoot *)photoshoot
{
    self.strPhotoshoot_photographer = photoshoot.photographer;
    self.strPhotoshoot_title = photoshoot.shootTitle;
    self.strPhotoshoot_description = photoshoot.shootDescription;
    self.strPhotoshoot_date = photoshoot.date;
    
    self.strPhotoshoot_city = photoshoot.city;
    self.strPhotoshoot_state = photoshoot.state;
    self.strPhotoshoot_country = photoshoot.country;
    
    self.imgPhotoshoot_signature = photoshoot.imgSignature;
    self.strPhotoshoot_signDate = photoshoot.strSignDate;
}

-(void)setPhotoshootPhotographer:(NSString *)photograhper Title:(NSString *)title Description:(NSString *)description Date:(NSString*)date City:(NSString *)city State:(NSString *)state Country:(NSString *)country
{
    self.strPhotoshoot_photographer = photograhper;
    self.strPhotoshoot_title = title;
    self.strPhotoshoot_description = description;
    self.strPhotoshoot_date = date;
    
    self.strPhotoshoot_city = city;
    self.strPhotoshoot_state = state;
    self.strPhotoshoot_country = country;
}

#pragma mark - model info

-(void)setModel:(Model *)model
{
    self.dataModel_photo = model.model_imgPhoto;
    self.strModel_name = model.model_name;
    self.strModel_birth = model.model_birth;
    if ([model.model_gender isEqual:[NSNumber numberWithBool:YES]])
    {
        self.strModel_gender = @"Male";
    }
    else
        self.strModel_gender = @"Female";
    
    self.strModel_ethnicity = model.model_ethnicity;
    self.strModel_parentName = model.model_parent;
    
    self.strModel_streetAddress = model.model_parent;
    self.strModel_city = model.model_city;
    self.strModel_state = model.model_state;
    self.strModel_country = model.model_country;
    self.strModel_zipCode = model.model_zipCode;
    
    self.strModel_email = model.model_email;
    self.strModel_phone = model.model_phone;
}

-(void)setModelPhoto:(NSData *)photo Name:(NSString *)name Birthday:(NSString *)birth Gender:(NSString *)gender Ethnicity:(NSString *)ethnicity ParentName:(NSString *)parentName
{
    self.dataModel_photo = photo;
    self.strModel_name = name;
    self.strModel_birth = birth;
    self.strModel_gender = gender;
    self.strModel_ethnicity = ethnicity;
    self.strModel_parentName = parentName;
}

-(void)setModelStreetAddress:(NSString *)streetAddress City:(NSString *)city State:(NSString *)state Country:(NSString *)country Zipcode:(NSString *)zipCode Email:(NSString *)email Phone:(NSString *)phone
{
    self.strModel_streetAddress = streetAddress;
    self.strModel_city = city;
    self.strModel_state = state;
    self.strModel_country = country;
    self.strModel_zipCode = zipCode;
    
    self.strModel_email = email;
    self.strModel_phone = phone;
}

-(void)setWitnessInfoName:(NSString *)name
{
    self.strWitness_name = name;
}

-(void)setModelSignImgData:(NSData *)imgData withDate:(NSString *)strDate
{
    self.imgModel_signatureData = imgData;
    self.strModel_signDate = strDate;
}

@end
