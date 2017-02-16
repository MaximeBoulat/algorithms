//
//  CribSheet.m
//  Algorithms
//
//  Created by Maxime Boulat on 2/10/17.
//  Copyright © 2017 Maxime Boulat. All rights reserved.
//

#import "CribSheet.h"

@implementation CribSheet


- (void) cribsheet {
	
#pragma mark - Blocks
	
	void (^writeBlock) (void)= ^ {
		// block execution goes here
	};
	
	void (^readBlock) (void)= ^ {
		// block execution goes here
	};
	
	NSArray * blocks = @[writeBlock, readBlock];
	
	void (^ myblock)() = blocks [0];
	myblock();
	
	
	#pragma mark - Grand Central Dispatch
	
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
			
			// background execution goes here
			
			dispatch_sync(dispatch_get_main_queue(), ^{
				
				// main thread evalution goes here
				
			});
			
		});
	
	 dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (double)3 * NSEC_PER_SEC);
	
	dispatch_after(delayTime, dispatch_get_main_queue(), ^(void){
		// dispatch something
	});
	
	#pragma mark - Random
	
	NSInteger random = arc4random_uniform(4);
	
}


@end

@interface CustomObject : NSObject

@property (nonatomic, strong) NSNumber * row;
@property (nonatomic, strong) NSNumber * column;
@property (nonatomic, strong) NSString * payload;

@end


@implementation CustomObject

- (instancetype)init
{
	self = [super init];
	if (self) {
		self.payload = @"";
	}
	return self;
}


@end
