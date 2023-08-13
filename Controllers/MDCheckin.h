//
//  MDCheckin.h
//  PlaceReminder
//
//  Created by Giorgio Coccapani on 28/07/23.
//

#import <Foundation/Foundation.h>
#import "Poi.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDCheckin : NSObject

@property (nonatomic, strong, readonly) Poi *poi;

@end

NS_ASSUME_NONNULL_END
