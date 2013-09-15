//
//  SERMintrisTile.m
//  Mintris
//
//  Created by Stanley Rost on 15.09.13.
//  Copyright (c) 2013 Stanley Rost. All rights reserved.
//

#import "SERMintrisTile.h"

@implementation SERMintrisTile

+ (instancetype)newTile
{
  int type = arc4random_uniform(SERMintrisTileTypeCount);
  
  SERMintrisTile *tile = [SERMintrisTile new];
  tile.type = type;
  
  return tile;
}

- (SERMintrisColorType)color
{
  SERMintrisColorType color = SERMintrisEmpty;
  switch (self.type)
  {
    case SERMintrisTileType1: color = SERMintrisColor1; break;
    case SERMintrisTileType2: color = SERMintrisColor2; break;
    case SERMintrisTileType3: color = SERMintrisColor3; break;
    case SERMintrisTileType4: color = SERMintrisColor4; break;
    case SERMintrisTileType5: color = SERMintrisColor5; break;
    case SERMintrisTileType6: color = SERMintrisColor6; break;
    case SERMintrisTileType7: color = SERMintrisColor7; break;
    default: break;
  }
  
  return color;
}

- (NSSet *)parts
{
  NSSet *set = nil;

  switch (self.type)
  {
    case SERMintrisTileType1: set = [[self class] squareBlockSet]; break;
    case SERMintrisTileType2: set = [[self class] iShapeSetForRotation:self.rotation]; break;
    case SERMintrisTileType3: set = [[self class] tShapeSetForRotation:self.rotation]; break;
    case SERMintrisTileType4: set = [[self class] lShapeSetForRotation:self.rotation]; break;
    case SERMintrisTileType5: set = [[self class] lReverseShapeSetForRotation:self.rotation]; break;
    case SERMintrisTileType6: set = [[self class] zShapeSetForRotation:self.rotation]; break;
    case SERMintrisTileType7: set = [[self class] zReverseShapeSetForRotation:self.rotation]; break;
    default: break;
  }
  
  return set;
}

- (void)rotateLeft
{
  [self rotate:NO];
}

- (void)rotateRight
{
  [self rotate:YES];
}

- (void)rotate:(BOOL)clockwise
{
  NSInteger diff = clockwise ? 1 : SERMintrisTileRotationCount - 1; // rotate n-1 times right = rotate left
  self.rotation = (diff + self.rotation) % SERMintrisTileRotationCount;
}

#pragma mark Shapes

+ (NSSet *)squareBlockSet
{
  NSMutableSet *set = [NSMutableSet new];
  [set addObject:@[@0, @0]];
  [set addObject:@[@1, @0]];
  [set addObject:@[@0, @-1]];
  [set addObject:@[@1, @-1]];
  
  return set;
}

+ (NSSet *)iShapeSetForRotation:(SERMintrisTileRotation)rotation
{
  NSMutableSet *set = [NSMutableSet new];

  if (rotation == SERMintrisTileRotation0 || rotation == SERMintrisTileRotation2)
  {
    [set addObject:@[@0, @0]];
    [set addObject:@[@0, @-1]];
    [set addObject:@[@0, @-2]];
    [set addObject:@[@0, @-3]];
  }
  else
  {
    [set addObject:@[@-1, @0]];
    [set addObject:@[@0, @0]];
    [set addObject:@[@1, @0]];
    [set addObject:@[@2, @0]];
  }
  
  return set;
}

+ (NSSet *)tShapeSetForRotation:(SERMintrisTileRotation)rotation
{
  NSMutableSet *set = [NSMutableSet new];

  if (rotation == SERMintrisTileRotation0)
  {
    [set addObject:@[@0, @0]];
    [set addObject:@[@-1, @-1]];
    [set addObject:@[@0, @-1]];
    [set addObject:@[@1, @-1]];
  }
  else if (rotation == SERMintrisTileRotation1)
  {
    [set addObject:@[@0, @0]];
    [set addObject:@[@0, @-1]];
    [set addObject:@[@0, @-2]];
    [set addObject:@[@-1, @-1]];
  }
  else if (rotation == SERMintrisTileRotation2)
  {
    [set addObject:@[@-1, @0]];
    [set addObject:@[@0, @0]];
    [set addObject:@[@1, @0]];
    [set addObject:@[@0, @-1]];
  }
  else if (rotation == SERMintrisTileRotation3)
  {
    [set addObject:@[@0, @0]];
    [set addObject:@[@0, @-1]];
    [set addObject:@[@0, @-2]];
    [set addObject:@[@1, @-1]];
  }
  
  return set;
}

+ (NSSet *)lShapeSetForRotation:(SERMintrisTileRotation)rotation
{
  NSMutableSet *set = [NSMutableSet new];

  if (rotation == SERMintrisTileRotation0)
  {
    [set addObject:@[@0, @0]];
    [set addObject:@[@0, @-1]];
    [set addObject:@[@0, @-2]];
    [set addObject:@[@-1, @-2]];
  }
  else if (rotation == SERMintrisTileRotation1)
  {
    [set addObject:@[@-1, @0]];
    [set addObject:@[@0, @0]];
    [set addObject:@[@1, @0]];
    [set addObject:@[@1, @-1]];
  }
  else if (rotation == SERMintrisTileRotation2)
  {
    [set addObject:@[@0, @0]];
    [set addObject:@[@1, @0]];
    [set addObject:@[@0, @-1]];
    [set addObject:@[@0, @-2]];
  }
  else if (rotation == SERMintrisTileRotation3)
  {
    [set addObject:@[@-1, @0]];
    [set addObject:@[@-1, @-1]];
    [set addObject:@[@0, @-1]];
    [set addObject:@[@1, @-1]];
  }
  
  return set;
}

+ (NSSet *)lReverseShapeSetForRotation:(SERMintrisTileRotation)rotation
{
  NSMutableSet *set = [NSMutableSet new];

  if (rotation == SERMintrisTileRotation0)
  {
    [set addObject:@[@0, @0]];
    [set addObject:@[@0, @-1]];
    [set addObject:@[@0, @-2]];
    [set addObject:@[@1, @-2]];
  }
  else if (rotation == SERMintrisTileRotation1)
  {
    [set addObject:@[@-1, @-1]];
    [set addObject:@[@0, @-1]];
    [set addObject:@[@1, @-1]];
    [set addObject:@[@1, @0]];
  }
  else if (rotation == SERMintrisTileRotation2)
  {
    [set addObject:@[@-1, @0]];
    [set addObject:@[@0, @0]];
    [set addObject:@[@0, @-1]];
    [set addObject:@[@0, @-2]];
  }
  else if (rotation == SERMintrisTileRotation3)
  {
    [set addObject:@[@-1, @0]];
    [set addObject:@[@0, @0]];
    [set addObject:@[@1, @0]];
    [set addObject:@[@-1, @-1]];
  }
  
  return set;
}

+ (NSSet *)zShapeSetForRotation:(SERMintrisTileRotation)rotation
{
  NSMutableSet *set = [NSMutableSet new];

  if (rotation == SERMintrisTileRotation0 || rotation == SERMintrisTileRotation2)
  {
    [set addObject:@[@0, @0]];
    [set addObject:@[@1, @0]];
    [set addObject:@[@-1, @-1]];
    [set addObject:@[@0, @-1]];
  }
  else
  {
    [set addObject:@[@0, @0]];
    [set addObject:@[@0, @-1]];
    [set addObject:@[@1, @-1]];
    [set addObject:@[@1, @-2]];
  }
  
  return set;
}

+ (NSSet *)zReverseShapeSetForRotation:(SERMintrisTileRotation)rotation
{
  NSMutableSet *set = [NSMutableSet new];

  if (rotation == SERMintrisTileRotation0 || rotation == SERMintrisTileRotation2)
  {
    [set addObject:@[@0, @0]];
    [set addObject:@[@-1, @0]];
    [set addObject:@[@0, @-1]];
    [set addObject:@[@1, @-1]];
  }
  else
  {
    [set addObject:@[@0, @0]];
    [set addObject:@[@0, @-1]];
    [set addObject:@[@-1, @-1]];
    [set addObject:@[@-1, @-2]];
  }
  
  return set;
}



@end
