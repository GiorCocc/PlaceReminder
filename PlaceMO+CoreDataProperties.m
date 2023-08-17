//
//  PlaceMO+CoreDataProperties.m
//  PlaceReminder
//
//  Created by Giorgio Coccapani on 17/08/23.
//
//

#import "PlaceMO+CoreDataProperties.h"

@implementation PlaceMO (CoreDataProperties)

+ (NSFetchRequest<PlaceMO *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Place"];
}

@dynamic address;
@dynamic name;
@dynamic notes;
@dynamic remember;
@dynamic insert_time;

@end
