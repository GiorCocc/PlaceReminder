//
//  AppDelegate.m
//  PlaceReminder
//
//  Created by Giorgio Coccapani on 23/07/23.
//
//	Geofence implementation with notification managment when user enter in a region

#import "AppDelegate.h"
#import "PlaceMO+CoreDataProperties.h"
#import "CoreDataManager.h"


@interface AppDelegate ()

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLCircularRegion *geofenceRegion;
@property (nonatomic, strong) NSArray *places;


@end



@implementation AppDelegate


- (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
	// location authorization
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestAlwaysAuthorization];
    
    // notification authorization
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (!error && granted) {
            NSLog(@"User granted notification authorization");
        }
    }];
    
    // database
    NSManagedObjectContext *context = [[CoreDataManager sharedManager] managedObjectContext];
    NSFetchRequest *fetchRequest = [PlaceMO fetchRequest];
    NSError *error = nil;
    self.places = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    if (error) {
        NSLog(@"Error loading places: %@", error);
    }
    
    // geofence
    CLLocationCoordinate2D coordinates;
    
    for (PlaceMO *place in self.places) {
        coordinates.latitude = place.latitude;
        coordinates.longitude = place.longitude;
            
        // crea la regione geografica ampia 500 metri
        self.geofenceRegion = [[CLCircularRegion alloc] initWithCenter:coordinates
                                                                    radius:500
                                                                identifier:place.name];
            
        NSLog(@"Geofence created: %@", self.geofenceRegion);
            
            
        // enter trigger (only for place with remember flag set)
        if (place.remember){
            self.geofenceRegion.notifyOnEntry = YES;
            
            [self.locationManager startMonitoringForRegion:self.geofenceRegion];
            
            NSLog(@"Listening for geofence: %@", self.geofenceRegion);
        }
    }
    
    return YES;
}

- (void) updateGeofenceSettings {
    NSLog(@"Update geofence settings");
    
    // get updated places from database
    NSManagedObjectContext *context = [[CoreDataManager sharedManager] managedObjectContext];
    NSFetchRequest *fetchRequest = [PlaceMO fetchRequest];
    NSError *error = nil;
    self.places = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    if (error) {
        NSLog(@"Error loading places: %@", error);
    }
    
    // remove old geofence
    [self.locationManager.monitoredRegions enumerateObjectsUsingBlock:^(CLRegion *region, BOOL *stop) {
        [self.locationManager stopMonitoringForRegion:region];
    }];
    
    // add new geofence
    for (PlaceMO *place in self.places) {
        CLLocationCoordinate2D center = CLLocationCoordinate2DMake(place.latitude, place.longitude);
        CLLocationDistance radius = 500.0;
        CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:center radius:radius identifier:place.name];
        
		// if the remider flag is set, listen for enter event and start monitoring
        if (place.remember) {
            region.notifyOnEntry = YES;
            region.notifyOnExit = NO;
            
            [self.locationManager startMonitoringForRegion:region];
        }
    }
}

- (void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [deviceToken description];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    NSLog(@"Device Token: %@", token);
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    NSLog(@"User entered in region: %@", region);

    NSString *placeName = region.identifier;
    
    // create notification
    NSString *title = [NSString stringWithFormat:@"You are near %@", placeName];
    NSString *body = [NSString stringWithFormat:@"%@ is an important place for you!", placeName];
    
    
    if ([region.identifier isEqualToString:region.identifier]) {
        [self scheduleNotificationWithTitle:title body:body];
    }
}

- (void) scheduleNotificationWithTitle: (NSString *) title body:(NSString *) body {
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = title;
    content.body = body;
    content.sound = UNNotificationSound.defaultSound;
    
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:NO];
    
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"MyNotification" content:content trigger:trigger];
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error adding notification request: %@", error);
        } else {
            NSLog(@"Notification request added successfully");
        }
    }];
}

- (void) userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    
    completionHandler();
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *) application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void) application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
