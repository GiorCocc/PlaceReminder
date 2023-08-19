//
//  AddNewPlaceTableViewController.h
//  PlaceReminder
//
//  Created by Giorgio Coccapani on 15/08/23.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "PlaceMO+CoreDataProperties.h"

NS_ASSUME_NONNULL_BEGIN

// delegate responsible for communicating with the HomePageViewController
@protocol AddNewPlaceDelegate <NSObject>

- (void) didAddNewPlace: (PlaceMO *)place;
- (void) didEditPlace: (PlaceMO *) place;

@end


@interface AddNewPlaceTableViewController : UITableViewController <CLLocationManagerDelegate>

@property (nonatomic, weak) id<AddNewPlaceDelegate> delegate;
@property (nonatomic, strong) PlaceMO *placeToEdit;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;


@end

NS_ASSUME_NONNULL_END
