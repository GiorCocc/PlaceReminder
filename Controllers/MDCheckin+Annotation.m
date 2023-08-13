//
//  MDCheckin+Annotation.m
//  PlaceReminder
//
//  Created by Giorgio Coccapani on 28/07/23.
//

#import "MDCheckin+Annotation.h"


@implementation MDCheckin (Annotation)

-(CLLocationCoordinate2D) coordinate{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = self.poi.latitude;
    coordinate.longitude = self.poi.longitude;
    return coordinate;
}

-(NSString *) title{
    return self.poi.name;
}


@end
