//
//  Place.h
//  PlaceReminder
//
//  Created by Giorgio Coccapani on 23/07/23. 
//

#import <Foundation/Foundation.h>

@interface Place : NSObject

@property (nonatomic, strong) NSString *name;           // name of the place
@property (nonatomic, strong) NSString *address;        // address of the place
@property (nonatomic, strong) NSString *latitude;       // latitude of the place (from the map)
@property (nonatomic, strong) NSString *longitude;      // longitude of the place (from the map)
@property (nonatomic, strong) NSString *category;       // category of the place
@property (nonatomic, strong) NSString *audioNote;      // audio note of the place (taken from the microphone)
@property (nonatomic, strong) NSString *reminder;       // reminder of the place
@property (nonatomic, strong) NSString *photo;          // photo of the place



- (instancetype)initWithName:(NSString *)name
                     address:(NSString *)address
                    latitude:(NSString *)latitude
                   longitude:(NSString *)longitude
                    category:(NSString *)category
                   audioNote:(NSString *)audioNote
                    reminder:(NSString *)reminder
                       photo:(NSString *)photo;



@end

