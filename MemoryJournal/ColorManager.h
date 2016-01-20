//
//  ColorManager.h
//  MemoryJournal
//
//  Created by Steve on 2016-01-15.
//  Copyright © 2016 Steve. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ColorManager : NSObject

// Home Page Color
+ (UIColor *)homeCheckInButtonBackGroundColor;
+ (UIColor *)homeCheckInButtonBorderColor;
+ (UIColor *)homeCheckInButtonTextColor;

// Add Post
+ (UIColor *)addPostDoneButtonTextColor;
+ (UIColor *)addPostDoneButtonBackgroundColor;
@end
