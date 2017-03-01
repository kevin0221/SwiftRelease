//
//  Property+CoreDataProperties.h
//  Swift Release
//
//  Created by beauty on 11/18/15.
//  Copyright © 2015 pixels. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Property.h"

NS_ASSUME_NONNULL_BEGIN

@interface Property (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *id;
@property (nullable, nonatomic, retain) NSNumber *photoshoot_id;
@property (nullable, nonatomic, retain) NSString *property_authorizedTitle;
@property (nullable, nonatomic, retain) NSString *property_city;
@property (nullable, nonatomic, retain) NSString *property_coporationName;
@property (nullable, nonatomic, retain) NSString *property_country;
@property (nullable, nonatomic, retain) NSString *property_description;
@property (nullable, nonatomic, retain) NSString *property_email;
@property (nullable, nonatomic, retain) NSData *property_imgPhoto;
@property (nullable, nonatomic, retain) NSData *property_imgSignature;
@property (nullable, nonatomic, retain) NSString *property_signDate;

@property (nullable, nonatomic, retain) NSString *property_individualOwnerName;
@property (nullable, nonatomic, retain) NSNumber *property_ownerType;
@property (nullable, nonatomic, retain) NSString *property_state;
@property (nullable, nonatomic, retain) NSString *property_streetAddress;
@property (nullable, nonatomic, retain) NSString *property_tel;
@property (nullable, nonatomic, retain) NSString *property_zipCode;
@property (nullable, nonatomic, retain) NSNumber *witness_id;

@property (nullable, nonatomic, retain) NSString *fileName;

@end

NS_ASSUME_NONNULL_END
