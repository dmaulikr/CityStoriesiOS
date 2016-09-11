//
//  MKMapView+ZoomLevel.h
//  StorySite
//
//  Created by Vicc Alexander on 9/10/16.
//  Copyright © 2016 StorySiteTeam. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKMapView (ZoomLevel)

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;

@end