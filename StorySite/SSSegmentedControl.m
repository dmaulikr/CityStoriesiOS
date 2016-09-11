//
//  SSSegmentedControl.m
//  StorySite
//
//  Created by Vicc Alexander on 9/11/16.
//  Copyright © 2016 StorySiteTeam. All rights reserved.
//

#import "SSSegmentedControl.h"
#import <ChameleonFramework/Chameleon.h>
#import <pop/pop.h>

@interface SSSegmentedControl ()

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *icons;
@property (nonatomic, strong) UIButton *slider;
@property (nonatomic, assign) BOOL isHorizontalPan;
@property (nonatomic, assign) int currentSegmentIndex;

@end

@implementation SSSegmentedControl

@synthesize selectionColors = _selectionColors;
@synthesize currentSegmentIndex = _currentSegmentIndex;

- (instancetype)initWithFrame:(CGRect)frame withTitles:(NSArray *)titles andIcons:(NSArray *)icons {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        //Setup Properties
        _titles = titles;
        _icons = icons;
        _items = [[NSMutableArray alloc] initWithCapacity:titles.count];
        
        //Setup Control
        [self setupControl];
    }
    
    return self;
}

#pragma mark - Setup Methods

- (void)setupControl {
    
    //Clear Items Array
    [self.items removeAllObjects];
    
    //Setup UI
    self.layer.cornerRadius = 4.0;
    self.clipsToBounds = YES;
    
    //Setup Sizes
    int margin = 4.0;
    //int itemWidth = self.frame.size.width / self.titles.count;
    int itemHeight = (self.frame.size.height);
    int sliderWidth = (self.frame.size.width - (margin * 2)) / self.titles.count;
    int sliderHeight = (self.frame.size.height - (margin * 2));
    
    //Setup Segments
    for (int i = 0; i < self.titles.count; i++) {
        
        //Create UIButton
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake((i * sliderWidth) + margin, 0, sliderWidth, itemHeight);
        button.backgroundColor = [UIColor clearColor];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:(NSString *)self.titles[i] forState:UIControlStateNormal];
        [button setImage:self.icons ? (UIImage *)self.icons[i] : nil forState:UIControlStateNormal];
        button.layer.cornerRadius = 4.0;
        button.tag = i;
        [button addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        //Add to Items Array
        [self.items addObject:button];
        
    }
    
    //Setup Slider at Index 0
    self.slider = [UIButton buttonWithType:UIButtonTypeSystem];
    self.slider.frame = CGRectMake(margin, margin, sliderWidth, sliderHeight);
    self.slider.layer.cornerRadius = 4.0;
    self.slider.tintColor = [UIColor whiteColor];
    [self.slider setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.slider.backgroundColor = self.selectionColors[0] ? self.selectionColors[0] : HexColor(@"ff4c4c");
    [self addSubview:self.slider];
    
    //Set Slider Text
    [self.slider setTitle:self.titles[0] ? self.titles[0] : @"" forState:UIControlStateNormal];
    [self.slider setImage:self.icons[0] ? self.icons[0] : nil forState:UIControlStateNormal];
}

#pragma mark - Gesture Recognizers

- (void)dragSlider:(UIPanGestureRecognizer *)recognizer {
    
    [self.slider.layer pop_removeAnimationForKey:@"move"];
    [self.slider.layer pop_removeAnimationForKey:@"snap"];
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan: {
            
            CGPoint translation = [recognizer translationInView:self];
            self.isHorizontalPan = fabs(translation.y) < fabs(translation.x); // BOOL property
            
            break;
        }
        case UIGestureRecognizerStateChanged: {
            
            if (self.isHorizontalPan) {
                
                CGPoint translation = [recognizer translationInView:self];
                CGPoint displacement = (self.isHorizontalPan) ? CGPointMake(translation.x, 0) : CGPointMake(0, translation.y);
                
                self.slider.transform = CGAffineTransformMakeTranslation(displacement.x, displacement.y);
            }
            
            break;
        }
            
        case UIGestureRecognizerStateEnded: {
            
            break;
        }
            
        case UIGestureRecognizerStateCancelled:
            break;
            
        default:
            break;
    }
}

#pragma mark - Public Methods

- (void)setCurrentSegmentIndex:(int)currentSegmentIndex animated:(BOOL)animated {
    
    //Set Current Segment Index
    self.currentSegmentIndex = currentSegmentIndex;
    
    //Update Selected Segment Location
    UIButton *selectedButton = (UIButton *)self.items[currentSegmentIndex];
    [self moveSliderToButton:selectedButton animated:animated];
}

#pragma mark - Action Methods

- (void)didTapButton:(UIButton *)button {
    
    //Update currently Selected Segment
    self.currentSegmentIndex = (int)button.tag;
    
    //Update Slider
    [self moveSliderToButton:button animated:YES];
}

- (void)moveSliderToButton:(UIButton *)button animated:(BOOL)animated {
    
    //Update Text
    [self.slider setBackgroundColor:self.selectionColors[button.tag]];
    [self.slider setTitle:self.titles[button.tag] ? self.titles[button.tag] : @"" forState:UIControlStateNormal];
    [self.slider setImage:self.icons[button.tag] ? self.icons[button.tag] : nil forState:UIControlStateNormal];
    
    if (animated) {
        
        //Animate Slider
        POPSpringAnimation *slideAnimation = [self.slider pop_animationForKey:@"slide"];
        if (slideAnimation) {
            
            slideAnimation.toValue = [NSValue valueWithCGPoint:button.center];
            
        } else {
            
            slideAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
            slideAnimation.toValue = [NSValue valueWithCGPoint:button.center];
            slideAnimation.springSpeed = 6;
            slideAnimation.springBounciness = 12;
            [self.slider pop_addAnimation:slideAnimation forKey:@"slide"];
        }
        
    } else {
        
        self.slider.center = button.center;
    }
}

#pragma mark - Setter Methods

- (void)setSelectionColors:(NSArray *)selectionColors {
    
    //Set Selected Colors
    _selectionColors = selectionColors;
}

- (void)setCurrentSegmentIndex:(int)currentSegmentIndex {
    
    //Set Current Segment Index
    _currentSegmentIndex = currentSegmentIndex;
    
    //Delegate
    if ([self.delegate respondsToSelector:@selector(segmentedControl:didSelectSegmentAtIndex:)]) {
        [self.delegate segmentedControl:self didSelectSegmentAtIndex:currentSegmentIndex];
    }
}

@end
