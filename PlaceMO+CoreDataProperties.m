//
//  PlaceMO+CoreDataProperties.m
//  PlaceReminder
//
//  Created by Giorgio Coccapani on 16/08/23.
//
//

#import "PlaceMO+CoreDataProperties.h"

@implementation PlaceMO (CoreDataProperties)

+ (NSFetchRequest<PlaceMO *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Place"];
}

@dynamic id;
@dynamic name;
@dynamic address;
@dynamic remember;
@dynamic notes;

@end
