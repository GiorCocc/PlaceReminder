//
//  Place.m
//  PlaceReminder
//
//  Created by Giorgio Coccapani on 23/07/23.
//
//  This class represent the model of the place where the pin is setted
//

#import "Place.h"

@implementation Place


- (instancetype)initWithName:(NSString *)name
                     address:(NSString *)address
                    latitude:(NSString *)latitude
                   longitude:(NSString *)longitude
                    category:(NSString *)category
                   audioNote:(NSString *)audioNote
                    reminder:(NSString *)reminder
                       photo:(NSString *)photo {
    
    self = [super init];
    
    if (self) {
        _name = [name copy];
        _address = [address copy];
        _latitude = [latitude copy];
        _longitude = [longitude copy];
        _category = [category copy];
        _audioNote = [audioNote copy];
        _reminder = [reminder copy];
        _photo = [photo copy];
    }
    
    return self;
}


- (NSString*) displayPlace{
        
        NSString *displayPlace = [NSString stringWithFormat:@"Name: %@\nAddress: %@\nCategory: %@\nReminder: %@\nAudioNote: %@\nPhoto: %@", self.name, self.address, self.category, self.reminder, self.audioNote, self.photo];
        
        return displayPlace;
    
}


@end

