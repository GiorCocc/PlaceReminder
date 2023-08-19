//
//  HomePageViewController.h
//  PlaceReminder
//
//  Created by Giorgio Coccapani on 17/08/23.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomePageViewController : UIViewController <UITableViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

NS_ASSUME_NONNULL_END
