//
//  MKBPrompter.h
//  MKBPrompter
//
//  Created by Mark Bridges .
//  Copyright (c) 2012 Mark Bridges. All rights reserved.
//
//	This class displays prompts for the user to rate your app or view your other apps at specified intervals

#import "MKBPrompter.h"
#import <StoreKit/StoreKit.h>

static NSString *mkbKeyRunCount = @"runCount";
static NSString *mkbKeyStopRatePrompting = @"stopRate";
static NSString *mkbKeyStopOtherAppPrompting = @"stopOtherApps";

static NSString *reviewLinkFormat = @"itms-apps://itunes.apple.com/app/id%@?action=write-review";
static NSString *companyLinkFormat = @"https://itunes.apple.com/developer/id%@";

@interface MKBPrompter ()

@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSBundle *bundle;

@end

@implementation MKBPrompter

- (instancetype)initWithAppID:(NSString*)appID companyName:(NSString*)companyName withRateCurrentAppPromptInterval:(NSInteger)rateCurrentInterval andOtherAppsPromptInterval:(NSInteger)otherAppsInterval
{
    if (self = [super init])
    {
        _appID = appID;
        _companyName = companyName;
        _rateCurrentAppPromptInterval = rateCurrentInterval;
        _otherAppsPromptInterval = otherAppsInterval;
    }
    return self;
}

- (NSBundle*)bundle
{
    if (_bundle == nil)
    {
        return [NSBundle bundleForClass:[MKBPrompter class]];
    }
    
    return _bundle;
}

- (NSUserDefaults*)userDefaults
{
    if (_userDefaults == nil)
    {
        _userDefaults = [NSUserDefaults standardUserDefaults];
    }
    
    return _userDefaults;
}

- (BOOL)showPrompterIfScheduledInViewController:(UIViewController*)viewController
{
    [self.userDefaults setInteger:(1 + [self.userDefaults integerForKey:mkbKeyRunCount]) forKey:mkbKeyRunCount];
    NSLog(@"MKBPrompter has been run %ld times", (long)[self.userDefaults integerForKey:mkbKeyRunCount]);
    
    if (![self.userDefaults boolForKey:mkbKeyStopRatePrompting] && (([self.userDefaults integerForKey:mkbKeyRunCount] % self.rateCurrentAppPromptInterval) == 0))
    {
#if !TARGET_OS_TV
        if (NSClassFromString(@"SKStoreReviewController"))
        {
            [SKStoreReviewController requestReview];
        }
        else
        {
            [viewController presentViewController:[self rateAppAlertController] animated:YES completion:nil];
            return YES;
        }
#else
        [viewController presentViewController:[self rateAppAlertController] animated:YES completion:nil];
        return YES;
#endif
    }
    
    if (![self.userDefaults boolForKey:mkbKeyStopOtherAppPrompting] && (([self.userDefaults integerForKey:mkbKeyRunCount] % self.otherAppsPromptInterval) == 0))
    {
        [viewController presentViewController:[self showOtherAppsAlertController] animated:YES completion:nil];
        return YES;
    }
    
    return NO;
}

- (UIAlertController*)rateAppAlertController
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedStringFromTableInBundle(@"Rate App", nil, self.bundle, @"Review app in the app store")
                                                                             message:NSLocalizedStringFromTableInBundle(@"Please leave a review so we can make this app even better", nil, self.bundle, nil)
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedStringFromTableInBundle(@"Remind Me Later", nil, self.bundle, @"remind me to review app later")
                                                        style:UIAlertActionStyleCancel
                                                      handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedStringFromTableInBundle(@"Rate Now", nil, self.bundle, @"go and rate this app in the app store")
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          [[UIApplication sharedApplication] openURL:[self reviewAppLink]];
                                                          [self.userDefaults setBool:TRUE forKey:mkbKeyStopRatePrompting];
                                                      }]];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedStringFromTableInBundle(@"Don't Ask Me Again", nil, self.bundle, nil)
                                                        style:UIAlertActionStyleDestructive
                                                      handler:^(UIAlertAction *action) {
                                                          [self.userDefaults setBool:TRUE forKey:mkbKeyStopRatePrompting];
                                                      }]];
    return alertController;
}

- (UIAlertController*)showOtherAppsAlertController
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedStringFromTableInBundle(@"See More Apps", nil, self.bundle, @"have a look at more of my apps")
                                                                             message:NSLocalizedStringFromTableInBundle(@"Please take a look at my other apps", nil, self.bundle, nil)
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedStringFromTableInBundle(@"Remind Me Later", nil, self.bundle, @"remind me to review app later")
                                                        style:UIAlertActionStyleCancel
                                                      handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedStringFromTableInBundle(@"Look Now", nil, self.bundle, @"Go to app store now")
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          [[UIApplication sharedApplication] openURL:[self moreAppsLink]];
                                                          [self.userDefaults setBool:TRUE forKey:mkbKeyStopOtherAppPrompting];
                                                      }]];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedStringFromTableInBundle(@"Don't Ask Me Again", nil, self.bundle, nil)
                                                        style:UIAlertActionStyleDestructive
                                                      handler:^(UIAlertAction *action) {
                                                          [self.userDefaults setBool:TRUE forKey:mkbKeyStopOtherAppPrompting];
                                                      }]];
    return alertController;
}

- (NSURL*)reviewAppLink
{
    return [NSURL URLWithString:[NSString stringWithFormat:reviewLinkFormat, self.appID]];
}
                                
- (NSURL*)moreAppsLink
{
    return [NSURL URLWithString:[NSString stringWithFormat:companyLinkFormat, self.companyName]];
}

@end
