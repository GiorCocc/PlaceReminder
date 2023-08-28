//
//  MapAnnotation.h
//  PlaceReminder
//
//  Created by Giorgio Coccapani on 18/08/23.
//
//  Custom MKPointAnnotation that stores the PlaceMO

#import <MapKit/MapKit.h>
#import "PlaceMO+CoreDataProperties.h"

NS_ASSUME_NONNULL_BEGIN

@interface MapAnnotation : MKPointAnnotation

@property (nonatomic, strong) PlaceMO *place;

@end

NS_ASSUME_NONNULL_END
