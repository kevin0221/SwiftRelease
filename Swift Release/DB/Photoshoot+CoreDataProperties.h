//
//  Photoshoot+CoreDataProperties.h
//  Swift Release
//
//  Created by beauty on 11/18/15.
//  Copyright © 2015 pixels. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Photoshoot.h"

NS_ASSUME_NONNULL_BEGIN

@interface Photoshoot (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *id;
@property (nullable, nonatomic, retain) NSString *photographer;
@property (nullable, nonatomic, retain) NSString *shootTitle;
@property (nullable, nonatomic, retain) NSString *shootDescription;
@property (nullable, nonatomic, retain) NSString *date;

@property (nullable, nonatomic, retain) NSString *city;
@property (nullable, nonatomic, retain) NSString *state;
@property (nullable, nonatomic, retain) NSString *country;

@property (nullable, nonatomic, retain) NSData *imgSignature;
@property (nullable, nonatomic, retain) NSString *strSignDate;

@property (nullable, nonatomic, retain) NSString *photographer_email;
@property (nullable, nonatomic, retain) NSString *company_name;
@property (nullable, nonatomic, retain) NSString *company_phone;
@property (nullable, nonatomic, retain) NSData *company_logo;

@property (nonatomic, retain) NSNumber *counter;

@end

NS_ASSUME_NONNULL_END
