//
//  PropertyRelease.m
//  Swift Release
//
//  Created by beauty on 11/10/15.
//  Copyright © 2015 pixels. All rights reserved.
//

#import "PropertyRelease.h"

@implementation PropertyRelease


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
    
    // Property Information
    self.dataProperty_photo = [[NSData alloc] init];
    self.strProperty_description = @"";
    self.strProperty_address = @"";
    self.strProperty_city = @"";
    self.strProperty_state = @"";
    self.strProperty_country = @"";
    self.strProperty_zipCode = @"";
    
    self.property_ownershipType = IndividualOwner;
    self.strProperty_Name = @"";
    
    self.strProperty_email = @"";
    self.strProperty_phone = @"";
    
    return self;
}

-(void)setPhotoshoot:(Photoshoot*)photoshoot
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

-(void)setWitnessInfoName:(NSString *)name
{
    self.strWitness_name = name;
}

-(void)setPropertyDescription:(NSString *)description Photo:(NSData*)imgData Address:(NSString *)address City:(NSString *)city State:(NSString *)state Country:(NSString *)country ZipCode:(NSString *)zipCode
{
    self.strProperty_description = description;
    
    self.dataProperty_photo = imgData;
    
    self.strProperty_address = address;
    self.strProperty_city = city;
    self.strProperty_state = state;
    self.strProperty_country = country;
    self.strProperty_zipCode = zipCode;
    
    
}

-(void)setOwnershipType:(OwnershipType)type PropertyName:(NSString *)name CorporationName:(NSString *)corporationName AuthorizedTitle:(NSString *)authorizedTitle Phone:(NSString *)phone Email:(NSString *)email
{
    [self setProperty_ownershipType:type];
    self.strProperty_Name = name;
    self.strProperty_corporationName = corporationName;
    self.strProperty_authorizedTitle = authorizedTitle;
    
    self.strProperty_phone = phone;
    self.strProperty_email = email;
}

-(void)setPropertySignImgData:(NSData *)imgSign date:(NSString *)strDate
{
    self.imgProperty_signature = imgSign;
    self.strProperty_signDate = strDate;
}


@end
