//
//  DataRelease.h
//  Swift Release
//
//  Created by beauty on 11/30/15.
//  Copyright © 2015 pixels. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum Release_Type
{
    NONE = 0,
    ModelType = 1,
    PropertyType = 2,
    MergeType = 3,
}ReleaseType;


@interface DataRelease : NSObject

// Photoshoot Information
@property(nonatomic, strong) NSString *strPhotoshoot_photographer;
@property(nonatomic, strong) NSString *strPhotoshoot_title;
@property(nonatomic, strong) NSString *strPhotoshoot_description;
@property(nonatomic, strong) NSString *strPhotoshoot_date;

@property(nonatomic, strong) NSString *strPhotoshoot_city;
@property(nonatomic, strong) NSString *strPhotoshoot_state;
@property(nonatomic, strong) NSString *strPhotoshoot_country;

@property(nonatomic, strong) NSData *imgPhotoshoot_signature;
@property(nonatomic, strong) NSString *strPhotoshoot_signDate;

@property(nonatomic, strong) NSString *strPhotoshoot_photographerEmail;
@property(nonatomic, strong) NSString *strPhotoshoot_companyName;
@property(nonatomic, strong) NSString *strPhotoshoot_companyPhone;
@property(nonatomic, strong) NSData *imgPhotoshoot_companyLogo;

// Witness Information
@property(nonatomic, strong) NSString *strWitness_name;
@property(nonatomic, strong) NSData *imgWitness_signature;
@property(nonatomic, strong) NSString *strWitness_signDate;

// Release Language
@property(nonatomic, strong) NSString *strLegalText;

@end
