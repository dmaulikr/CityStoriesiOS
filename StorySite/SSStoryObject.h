//
//  SSStoryObject.h
//  StorySite
//
//  Created by Vicc Alexander on 9/11/16.
//  Copyright © 2016 StorySiteTeam. All rights reserved.
//

#import <Parse/Parse.h>

@interface SSStoryObject : PFObject <PFSubclassing>

#pragma mark - Class Methods

+ (NSString *)parseClassName;

#pragma mark - Properties

@property (nonatomic, strong) NSString *info;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) PFGeoPoint *geoLocation;

@end
