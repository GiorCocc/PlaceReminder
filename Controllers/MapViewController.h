//
//  MapViewController.h
//  PlaceReminder
//
//  Created by Giorgio Coccapani on 28/07/23.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MapViewController : UIViewController <MKMapViewDelegate> {
    MKMapView *mapView;
}

@property (nonatomic, weak) IBOutlet MKMapView *mapView;

@end

NS_ASSUME_NONNULL_END
