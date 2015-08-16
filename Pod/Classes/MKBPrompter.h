//
//  MKBPrompter.h
//  MKBPrompter
//
//  Created by Mark Bridges .
//  Copyright (c) 2012 Mark Bridges. All rights reserved.
//
//	This class displays prompts for the user to rate your app or view your other apps at specified intervals

#import <Foundation/Foundation.h>

@interface MKBPrompter : NSObject

@property (nonatomic, strong) NSString *appID;
@property (nonatomic, strong) NSString *companyName;
@property (nonatomic, readwrite) NSInteger rateCurrentAppPromptInterval;
@property (nonatomic, readwrite) NSInteger otherAppsPromptInterval;

- (instancetype)initWithAppID:(NSString*)appID companyName:(NSString*)companyName withRateCurrentAppPromptInterval:(NSInteger)rateCurrentInterval andOtherAppsPromptInterval:(NSInteger)otherAppsInterval;
- (BOOL)showPrompterIfScheduledInViewController:(UIViewController*)viewController;

@end
