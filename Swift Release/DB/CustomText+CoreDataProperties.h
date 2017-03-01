//
//  CustomText+CoreDataProperties.h
//  
//
//  Created by beauty on 3/14/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CustomText.h"

NS_ASSUME_NONNULL_BEGIN

@interface CustomText (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *content;

@end

NS_ASSUME_NONNULL_END
