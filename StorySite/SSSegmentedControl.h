//
//  SSSegmentedControl.h
//  StorySite
//
//  Created by Vicc Alexander on 9/11/16.
//  Copyright © 2016 StorySiteTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SSSegmentedControlDelegate;

@interface SSSegmentedControl : UIView

- (instancetype)initWithFrame:(CGRect)frame withTitles:(NSArray *)titles andIcons:(NSArray *)icons;

@property (nonatomic, strong) NSArray *selectionColors;
@property (nonatomic, readonly) int currentSegmentIndex;
@property (nonatomic, weak) id <SSSegmentedControlDelegate> delegate;

/**
 *  @author Vicc Alexander
 *
 *  Sets the current segment to the specified index.
 *
 *  @param currentSegmentIndex The segment to slide the slider to.
 *  @param animated            A boolean.
 *
 *  @since 1.0
 */
- (void)setCurrentSegmentIndex:(int)currentSegmentIndex animated:(BOOL)animated;

@end

@protocol SSSegmentedControlDelegate <NSObject>
@optional

- (void)segmentedControl:(SSSegmentedControl *)segmentedControl didSelectSegmentAtIndex:(int)index;

@end



