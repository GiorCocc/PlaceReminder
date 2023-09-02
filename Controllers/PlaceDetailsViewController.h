//
//  TablePinnedPlaceViewController.h
//  PlaceReminder
//
//  Created by Giorgio Coccapani on 28/07/23.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "PlaceMO+CoreDataProperties.h"
#import "AddNewPlaceTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PlaceDetailsDelegate <NSObject>

- (void) didRemovePlace: (PlaceMO *) place;

@end


@interface PlaceDetailsViewController : UITableViewController <AddNewPlaceDelegate>

@property (nonatomic, strong) PlaceMO *selectedPlaceMO;
@property (nonatomic, weak) id<PlaceDetailsDelegate> delegate;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

- (void) updateUIWithData: (PlaceMO *) place;

@end

NS_ASSUME_NONNULL_END
