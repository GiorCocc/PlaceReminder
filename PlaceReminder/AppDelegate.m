//
//  AppDelegate.m
//  PlaceReminder
//
//  Created by Giorgio Coccapani on 23/07/23.
//

#import "AppDelegate.h"
#import "PlaceMO+CoreDataProperties.h"
#import "CoreDataManager.h"


@interface AppDelegate ()

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLCircularRegion *geofenceRegion;
@property (nonatomic, strong) NSArray *places;


@end



@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestAlwaysAuthorization];
    
    // Richiedi l'autorizzazione per le notifiche
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (!error && granted) {
            NSLog(@"User granted notification authorization");
        }
    }];
    
    // Esegui la query per ottenere i luoghi dal database
    NSManagedObjectContext *context = [[CoreDataManager sharedManager] managedObjectContext];
    NSFetchRequest *fetchRequest = [PlaceMO fetchRequest];
    NSError *error = nil;
    self.places = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    if (error) {
        NSLog(@"Errore nel caricamento dei luoghi: %@", error);
    }
    
    CLLocationCoordinate2D coordinates;
    
    for (PlaceMO *place in self.places) {
        if (place.remember) {
            coordinates.latitude = place.latitude;
            coordinates.longitude = place.longitude;
            
            // crea la regione geografica ampia 500 metri
            self.geofenceRegion = [[CLCircularRegion alloc] initWithCenter:coordinates
                                                                    radius:500
                                                                identifier:@"MyGeofence"];
            
            NSLog(@"Regione geografica creata: %@", self.geofenceRegion);
            
            
            // imposta l'ingresso nella regione come trigger
            self.geofenceRegion.notifyOnEntry = YES;
            
            // registra la regione geografica
            [self.locationManager startMonitoringForRegion:self.geofenceRegion];
        
            
        }
    }
    
    
        
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [deviceToken description];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    NSLog(@"Device Token: %@", token);
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    NSLog(@"Entrato nella regione: %@", region);
    
    if ([region.identifier isEqualToString:@"MyGeofence"]) {
        [self scheduleNotificationWithTitle:@"Luogo importante"
                                       body:@"Sei vicino a un luogo importante per te!"];
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



- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    // Gestisci la notifica ricevuta
    completionHandler();
}




#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
