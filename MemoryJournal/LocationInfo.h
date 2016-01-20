//
//  LocationInfo.h
//  MemoryJournal
//
//  Created by Steve on 2016-01-15.
//  Copyright © 2016 Steve. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface LocationInfo : PFObject <PFSubclassing>

@property (strong, nonatomic) PFGeoPoint *currentLocation;

@end
