//
//  R.m
//
//  Created by neacao
//

#define L_STR(key) [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:key];

#import "R.h"

@implementation R

+ (NSString *)title1 {
	return L_STR(@"title1");
}

+ (NSString *)title2 {
	return L_STR(@"title2");
}

// <REPLACE>

@end
