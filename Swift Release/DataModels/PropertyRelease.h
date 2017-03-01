//
//  PropertyRelease.h
//  Swift Release
//
//  Created by beauty on 11/10/15.
//  Copyright © 2015 pixels. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataRelease.h"
#import "Photoshoot.h"

typedef enum Ownership_Type
{
    IndividualOwner = 0,
    CorporateOwner = 1,
    AuthorizedRepresentative = 2,
}OwnershipType;


@interface PropertyRelease : DataRelease


// Property Information
@property(nonatomic, strong) NSData *dataProperty_photo;
@property(nonatomic, strong) NSString *strProperty_description;
@property(nonatomic, strong) NSString *strProperty_address;
@property(nonatomic, strong) NSString *strProperty_city;
@property(nonatomic, strong) NSString *strProperty_state;
@property(nonatomic, strong) NSString *strProperty_country;
@property(nonatomic, strong) NSString *strProperty_zipCode;

// Ownership information
@property OwnershipType property_ownershipType;
@property(nonatomic, strong) NSString *strProperty_Name;
@property(nonatomic, strong) NSString *strProperty_corporationName;
@property(nonatomic, strong) NSString *strProperty_authorizedTitle;

@property(nonatomic, strong) NSString *strProperty_email;
@property(nonatomic, strong) NSString *strProperty_phone;

// Signature Imagedata
@property(nonatomic, strong) NSData *imgProperty_signature;
@property(nonatomic, strong) NSString *strProperty_signDate;

// PDF file name
@property(nonatomic, strong) NSString *strFileName;

-(instancetype) init;

-(void)setPhotoshoot:(Photoshoot*)photoshoot;

-(void)setPhotoshootPhotographer:(NSString*)photograhper Title:(NSString*)title Description:(NSString*)description Date:(NSString*)date City:(NSString*)city State:(NSString*)state Country:(NSString*)country;
-(void)setWitnessInfoName:(NSString*)name;

-(void)setPropertyDescription:(NSString *)description Photo:(NSData*)imgData Address:(NSString*)address City:(NSString*)city State:(NSString*)state Country:(NSString*)country ZipCode:(NSString*)zipCode;
-(void)setOwnershipType:(OwnershipType)type PropertyName:(NSString*)name CorporationName:(NSString*)corporationName AuthorizedTitle:(NSString*)authorizedTitle Phone:(NSString*)phone Email:(NSString*)email;

-(void)setPropertySignImgData:(NSData*)imgSign date:(NSString*)strDate;

@end
