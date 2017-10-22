//
//  LocationViewController.m
//  Location
//
//  Created by Ling

#import "LocationViewController.h"
#import "LocationTracker.h"

@interface LocationViewController ()

@end

@implementation LocationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpLocationTraker{
    self.locationTracker = [[LocationTracker alloc]init];
    [self.locationTracker startLocationTracking];
    //time interval
    NSTimeInterval time = 10.0;
    //timer start
    self.locationUpdateTimer =
    [NSTimer scheduledTimerWithTimeInterval:time
                                     target:self
                                   selector:@selector(updateLocation)
                                   userInfo:nil
                                    repeats:YES];
}

-(void)updateLocation {
    NSLog(@"Waiting...");
    //sending location to server
    [self.locationTracker updateLocationToServer];
}

@end
