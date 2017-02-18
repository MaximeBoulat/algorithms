//
//  GameCollectionViewController.h
//  Algorithms
//
//  Created by Maxime Boulat on 2/3/17.
//  Copyright © 2017 Maxime Boulat. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GameCollectionViewController : UICollectionViewController 

@end

typedef NS_ENUM(NSInteger, TileType) {
	pilot = 0,
	startingPoint,
	goal,
	path,
	none
};

@interface GameTile : NSObject

@property (nonatomic, assign) BOOL isWall;
@property (nonatomic, assign) BOOL visited;

@property (nonatomic, assign) TileType type;
@property (nonatomic, assign) NSInteger score;

@property (nonatomic, assign) NSInteger row;
@property (nonatomic, assign) NSInteger column;

@property (nonatomic, retain) NSMutableArray * neighbors;


@end



