//
//  TablePinnedPlaceViewController.h
//  PlaceReminder
//
//  Created by Giorgio Coccapani on 28/07/23.
//

#import <UIKit/UIKit.h>
#import "PlaceMO+CoreDataProperties.h"

NS_ASSUME_NONNULL_BEGIN

@interface PlaceDetailsViewController : UITableViewController

@property (nonatomic, strong) PlaceMO *selectedPlaceMO;

@end

NS_ASSUME_NONNULL_END
