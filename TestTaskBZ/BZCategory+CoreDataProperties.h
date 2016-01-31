//
//  BZCategory+CoreDataProperties.h
//  TestTaskBZ
//
//  Created by User on 27.01.16.
//  Copyright © 2016 BZ. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "BZCategory.h"

NS_ASSUME_NONNULL_BEGIN

@interface BZCategory (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *categoryName;
@property (nullable, nonatomic, retain) NSSet<BZQuestion *> *questions;

@end

@interface BZCategory (CoreDataGeneratedAccessors)

- (void)addQuestionsObject:(BZQuestion *)value;
- (void)removeQuestionsObject:(BZQuestion *)value;
- (void)addQuestions:(NSSet<BZQuestion *> *)values;
- (void)removeQuestions:(NSSet<BZQuestion *> *)values;

@end

NS_ASSUME_NONNULL_END
