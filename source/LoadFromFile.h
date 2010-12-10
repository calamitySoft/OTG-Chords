//
//  LoadFromFile.h
//  OTG-Chords
//
//  Created by Logan Moseley on 12/9/10.
//  Copyright 2010 CalamitySoft. All rights reserved.
//

//
//	Usage:
//	NSInteger error = [LoadFromFile getObject:&obj forKey:@"IntervalNames"];
//
//	error	-2	object for that key does not exist
//			-1	key == nil
//			 1	successfully found key and placed its object in arg object
//


#import <Foundation/Foundation.h>


@interface LoadFromFile : NSObject {	
}

+ (NSInteger)getObject:(NSObject**)object forKey:(NSString*)key;

@end
