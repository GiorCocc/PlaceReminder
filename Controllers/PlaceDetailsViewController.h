//
//  TablePinnedPlaceViewController.h
//  PlaceReminder
//
//  Created by Giorgio Coccapani on 28/07/23.
//

#import <UIKit/UIKit.h>
#import "PlaceMO+CoreDataProperties.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PlaceDetailsDelegate <NSObject>

- (void) didRemovePlace: (PlaceMO *)place;

@end

@interface PlaceDetailsViewController : UITableViewController

@property (nonatomic, strong) PlaceMO *selectedPlaceMO;
@property (nonatomic, weak) id<PlaceDetailsDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
