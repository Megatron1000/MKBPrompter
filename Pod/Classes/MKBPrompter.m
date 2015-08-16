//
//  MKBPrompter.h
//  MKBPrompter
//
//  Created by Mark Bridges .
//  Copyright (c) 2012 Mark Bridges. All rights reserved.
//
//	This class displays prompts for the user to rate your app or view your other apps at specified intervals

#import "MKBPrompter.h"

static NSString *mkbKeyRunCount = @"runCount";
static NSString *mkbKeyStopRatePrompting = @"stopRate";
static NSString *mkbKeyStopOtherAppPrompting = @"stopOtherApps";

static NSString *reviewLinkFormat = @"itms-apps://itunes.apple.com/app/id%@";
static NSString *companyLinkFormat = @"itms-apps://itunes.com/apps/%@";

@interface MKBPrompter ()

@property (nonatomic, strong) NSUserDefaults *userDefaults;

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
    UIAlertController *alertController;
    
    [self.userDefaults setInteger:(1 + [self.userDefaults integerForKey:mkbKeyRunCount]) forKey:mkbKeyRunCount];
    NSLog(@"MKBPrompter has been run %ld times", (long)[self.userDefaults integerForKey:mkbKeyRunCount]);
    
    if (![self.userDefaults boolForKey:mkbKeyStopRatePrompting] && (([self.userDefaults integerForKey:mkbKeyRunCount] % self.rateCurrentAppPromptInterval) == 0))
    {
        alertController = [self rateAppAlertController];
    }
    
    if (![self.userDefaults boolForKey:mkbKeyStopOtherAppPrompting] && (([self.userDefaults integerForKey:mkbKeyRunCount] % self.otherAppsPromptInterval) == 0))
    {
        alertController = [self showOtherAppsAlertController];
    }
    
    if (alertController)
    {
        [viewController presentViewController:alertController animated:YES completion:nil];
        return YES;
    }
    else
    {
        return NO;
    }
}

- (UIAlertController*)rateAppAlertController
{
	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Rate App", @"Review app in the app store")
                                                                             message:NSLocalizedString(@"Please leave a review so we can make this app even better", nil)
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Remind Me Later", @"remind me to review app later")
                                                        style:UIAlertActionStyleCancel
                                                      handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Rate Now", @"go and rate this app in the app store")
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          [[UIApplication sharedApplication] openURL:[self reviewAppLink]];
                                                          [self.userDefaults setBool:TRUE forKey:mkbKeyStopRatePrompting];
                                                      }]];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Don't Ask Me Again", nil)
                                                        style:UIAlertActionStyleDestructive
                                                      handler:^(UIAlertAction *action) {
                                                          [self.userDefaults setBool:TRUE forKey:mkbKeyStopRatePrompting];
                                                      }]];
    return alertController;
}

- (UIAlertController*)showOtherAppsAlertController
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"See More Apps", @"have a look at more of my apps")
                                                                             message:NSLocalizedString(@"Please take a look at my other apps", nil)
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Remind Me Later", @"remind me to review app later")
                                                        style:UIAlertActionStyleCancel
                                                      handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Look Now", @"Go to app store now")
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          [[UIApplication sharedApplication] openURL:[self moreAppsLink]];
                                                          [self.userDefaults setBool:TRUE forKey:mkbKeyStopOtherAppPrompting];
                                                      }]];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Don't Ask Me Again", nil)
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
