//
//  SERMintrisTile.h
//  Mintris
//
//  Created by Stanley Rost on 15.09.13.
//  Copyright (c) 2013 Stanley Rost. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SERMintrisColor.h"

typedef NS_ENUM(NSInteger, SERMintrisTileType) {
  SERMintrisTileType1,
  SERMintrisTileType2,
  SERMintrisTileType3,
  SERMintrisTileType4,
  SERMintrisTileType5,
  SERMintrisTileType6,
  SERMintrisTileType7,
  SERMintrisTileTypeCount
};

typedef NS_ENUM(NSInteger, SERMintrisTileRotation) {
  SERMintrisTileRotation0,
  SERMintrisTileRotation1,
  SERMintrisTileRotation2,
  SERMintrisTileRotation3,
  SERMintrisTileRotationCount
};

@interface SERMintrisTile : NSObject

@property (nonatomic) SERMintrisTileType type;

@property (nonatomic) NSInteger positionX;
@property (nonatomic) NSInteger positionY;
@property (nonatomic) SERMintrisTileRotation rotation;

+ (instancetype)newTile;

- (NSSet *)parts;
- (SERMintrisColorType)color;
- (void)rotateLeft;
- (void)rotateRight;

@end
