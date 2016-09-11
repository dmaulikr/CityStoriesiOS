//
//  SSStoryObject.m
//  StorySite
//
//  Created by Vicc Alexander on 9/11/16.
//  Copyright © 2016 StorySiteTeam. All rights reserved.
//

#import "SSStoryObject.h"
#import <Parse/PFObject+Subclass.h>

@implementation SSStoryObject

@synthesize name, info, geoLocation, type;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Story";
}

@end
