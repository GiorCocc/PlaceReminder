//
//  AppDelegate.h
//  PlaceReminder
//
//  Created by Giorgio Coccapani on 23/07/23.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (nonatomic, weak) id<CLLocationManagerDelegate> delegate;

- (void) updateGeofenceSettings;

@end

