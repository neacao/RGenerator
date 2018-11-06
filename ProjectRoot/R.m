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

+ (NSString *)writeRClass {
	return LOCALIZE_STRING(@"writeRClass");
}

+ (NSString *)writeRClass {
	return LOCALIZE_STRING(@"writeRClass");
}

// <REPLACE>

@end
