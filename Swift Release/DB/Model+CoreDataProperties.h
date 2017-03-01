//
//  Model+CoreDataProperties.h
//  Swift Release
//
//  Created by beauty on 11/18/15.
//  Copyright © 2015 pixels. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Model.h"

NS_ASSUME_NONNULL_BEGIN

@interface Model (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *id;
@property (nullable, nonatomic, retain) NSString *model_birth;
@property (nullable, nonatomic, retain) NSString *model_city;
@property (nullable, nonatomic, retain) NSString *model_country;
@property (nullable, nonatomic, retain) NSString *model_email;
@property (nullable, nonatomic, retain) NSString *model_ethnicity;
@property (nullable, nonatomic, retain) NSNumber *model_gender;
@property (nullable, nonatomic, retain) NSData *model_imgPhoto;
@property (nullable, nonatomic, retain) NSData *model_imgSignature;
@property (nullable, nonatomic, retain) NSString *model_signDate;
@property (nullable, nonatomic, retain) NSString *model_name;
@property (nullable, nonatomic, retain) NSString *model_parent;
@property (nullable, nonatomic, retain) NSString *model_phone;
@property (nullable, nonatomic, retain) NSString *model_state;
@property (nullable, nonatomic, retain) NSString *model_streetAdress;
@property (nullable, nonatomic, retain) NSString *model_zipCode;
@property (nullable, nonatomic, retain) NSNumber *photoshoot_id;
@property (nullable, nonatomic, retain) NSNumber *witness_id;
@property (nullable, nonatomic, retain) NSString *fileName;

@end

NS_ASSUME_NONNULL_END
