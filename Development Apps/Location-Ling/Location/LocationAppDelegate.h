//
//  LocationAppDelegate.h
//  Location
//
//  Created by Ling

#import <UIKit/UIKit.h>
#import "LocationTracker.h"

@interface LocationAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property LocationTracker * locationTracker;
@property (nonatomic) NSTimer* locationUpdateTimer;

@end
