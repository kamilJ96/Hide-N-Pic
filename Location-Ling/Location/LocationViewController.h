//
//  LocationViewController.h
//  Location
//
//  Created by Ling

#import <UIKit/UIKit.h>
#import "LocationTracker.h"

@interface LocationViewController : UIViewController
@property LocationTracker * locationTracker;
@property (nonatomic) NSTimer* locationUpdateTimer;

@end
