//
//  Poi.m
//  PlaceReminder
//
//  Created by Giorgio Coccapani on 24/07/23.
//

#import "Poi.h"

@implementation Poi

- (instancetype)initWithName:(NSString *)name
                    latitude:(double)latitude
                   longitude:(double)longitude {
    
    self = [super init];
    
    if (self) {
        _name = [name copy];
        _latitude = latitude;
        _longitude = longitude;
    }
    
    return self;
}

@end
