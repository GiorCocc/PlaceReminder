//
//  Poi.h
//  PlaceReminder
//
//  Created by Giorgio Coccapani on 24/07/23.
//

#include <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Poi : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, readonly) double latitude;
@property (nonatomic, readonly) double longitude;

- (instancetype)initWithName:(NSString *)name
                    latitude:(double)latitude
                   longitude:(double)longitude;

@end

NS_ASSUME_NONNULL_END
