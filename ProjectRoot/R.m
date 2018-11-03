//
//  R.m
//
//  Created by neacao
//

#define LOCALIZE_STRING(key) [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:key];

#import "R.h"

@implementation R

+ (NSString *)title1 {
	return LOCALIZE_STRING(@"title1");
}

// <REPLACE>

@end
