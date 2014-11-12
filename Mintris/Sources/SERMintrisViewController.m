//
//  SERMintrisViewController.m
//  Mintris
//
//  Created by Stanley Rost on 15.09.13.
//  Copyright (c) 2013 Stanley Rost. All rights reserved.
//

static const NSUInteger kBoardWidth  = 10;
static const NSUInteger kBoardHeight = 20;
static const CGFloat    kTileSize    = 20.0;
static const float      kStartFrequency = 1.666; // heartbeats per second

#import "SERMintrisViewController.h"
#import "SERMintrisTile.h"
#import "SERMintrisColor.h"

@interface SERMintrisViewController ()

@property (nonatomic) BOOL isRunning;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) float frequency;

@property (nonatomic, strong) SERMintrisTile *currentTile;

@property (nonatomic, strong) NSSet *tileLayers;
@property (nonatomic, strong) NSSet *currentTileLayers;

@property (nonatomic) NSInteger noOfRowsCleared;

@end

@implementation SERMintrisViewController
{
  int _matrix[kBoardHeight][kBoardWidth];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.isRunning = NO;
  self.statusLabel.text = @"Press start";
}

#pragma mark Actions

- (IBAction)startButtonPressed:(id)sender
{
  if (self.isRunning)
    return;

  self.isRunning = YES;
}

- (IBAction)stopButtonPressed:(id)sender
{
  if (!self.isRunning)
    return;
  
  self.isRunning = NO;
}

- (IBAction)leftButtonPressed:(id)sender
{
  NSInteger newX = self.currentTile.positionX - 1;
  NSInteger y    = self.currentTile.positionY;
  
  if ([self isValidPositionForTile:self.currentTile x:newX y:y])
  {
    self.currentTile.positionX = newX;
    [self drawTile];
  }
}

- (IBAction)righButtonPressed:(id)sender
{
  NSInteger newX = self.currentTile.positionX + 1;
  NSInteger y    = self.currentTile.positionY;
  
  if ([self isValidPositionForTile:self.currentTile x:newX y:y])
  {
    self.currentTile.positionX = newX;
    [self drawTile];
  }
}

- (IBAction)downButtonPressed:(id)sender
{
  NSInteger x    = self.currentTile.positionX;
  NSInteger newY = self.currentTile.positionY;
  
  while ([self isValidPositionForTile:self.currentTile x:x y:newY])
  {
    ++newY;
  }
  
  --newY; // and one back, because we overshot
  
  if (newY > self.currentTile.positionY)
  {
    self.currentTile.positionY = newY;
    [self drawTile];
  }
}
  
- (IBAction)rotateLeftButtonPressed:(id)sender
{
  [self.currentTile rotateLeft];
  if (![self isValidPositionForTile:self.currentTile])
  {
    [self.currentTile rotateRight]; // revert
  }
  else
  {
    [self drawTile];
  }
}

- (IBAction)rotateRightButtonPressed:(id)sender
{
  [self.currentTile rotateRight];
  if (![self isValidPositionForTile:self.currentTile])
  {
    [self.currentTile rotateLeft]; // revert
  }
  else
  {
    [self drawTile];
  }
}

#pragma mark Game

- (void)setIsRunning:(BOOL)isRunning
{
  if (isRunning)
  {
    self.frequency = kStartFrequency;
    float interval = 1.0 / self.frequency;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(heartbeat:) userInfo:nil repeats:YES];
    
    [self prepare];
    [self heartbeat:nil];
  }
  else
  {
    [self.timer invalidate];
  }
  
  self.startButton.enabled = !isRunning;
  self.stopButton.enabled  = isRunning;
  
  _isRunning = isRunning;
}

- (void)setFrequency:(float)frequency
{
  _frequency = frequency;
  
  self.statusLabel.text = [NSString stringWithFormat:@"%.2f", frequency];
}

- (void)levelUp
{
  self.frequency *= 1.2;

  [self.timer invalidate];
  self.timer = nil;

  float interval = 1.0 / self.frequency;
  self.timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(heartbeat:) userInfo:nil repeats:YES];
  
  self.statusLabel.text = @"Level up!";
}

- (void)prepare
{
  for (NSUInteger y = 0; y < kBoardHeight; ++y)
    for (NSUInteger x = 0; x < kBoardWidth; ++x)
      _matrix[y][x] = SERMintrisEmpty;
  
  [self.tileLayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
  self.tileLayers = nil;

  self.currentTile = nil;
  [self.currentTileLayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
  self.currentTileLayers = nil;
  
  self.noOfRowsCleared = 0;
}

- (void)heartbeat:(NSTimer *)timer
{
  if (!self.currentTile)
  {
    [self createNewTile];
  }
  
  [self advanceTile:self.currentTile];
  [self drawGrid];
}

- (void)drawGrid
{
  [self.tileLayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
  
  NSMutableSet *newTileLayers = [NSMutableSet setWithCapacity:kBoardWidth * kBoardHeight];
  for (NSUInteger y = 0; y < kBoardHeight; ++y)
  {
    for (NSUInteger x = 0; x < kBoardWidth; ++x)
    {
      SERMintrisColorType color = _matrix[y][x];
      if (color != SERMintrisEmpty)
      {
        CAShapeLayer *layer = [self createShapeLayerForX:x y:y color:color];
        [newTileLayers addObject:layer];
        [self.gameView.layer addSublayer:layer];
      }
    }
  }
  
  self.tileLayers = newTileLayers;
}

- (CAShapeLayer *)createShapeLayerForX:(NSUInteger)x y:(NSUInteger)y color:(SERMintrisColorType)color
{
  UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(x * kTileSize + 1, y * kTileSize + 1, kTileSize - 2, kTileSize - 2)];
  
  UIColor *uicolor = [SERMintrisColor colorForColor:color];
  
  CAShapeLayer *layer = [CAShapeLayer new];
  layer.path = [path CGPath];
  layer.fillColor = [uicolor CGColor];
  layer.strokeColor = [[UIColor whiteColor] CGColor];
  layer.lineWidth = 1.0;
  
  return layer;
}

- (void)advanceTile:(SERMintrisTile *)tile
{
  NSInteger x = tile.positionX;
  NSInteger y = tile.positionY + 1;
  
  BOOL isValid = [self isValidPositionForTile:tile x:x y:y];
  
  if (isValid)
  {
    tile.positionY = y;
    [self drawTile];
  }
  else
  {
    NSInteger largestRowIndex = -1;
    for (NSArray *part in tile.parts)
    {
      NSInteger partX = [[part firstObject] integerValue] + tile.positionX;
      NSInteger partY = [[part lastObject] integerValue] + tile.positionY;
    
      _matrix[partY][partX] = tile.color;
      largestRowIndex = MAX(largestRowIndex, partY);
    }
    
    NSInteger numberOfRowsClearedinThisTurn = [self checkAndClearRowsFromIndex:largestRowIndex];
    [self checkLevelUp:numberOfRowsClearedinThisTurn];
    [self createNewTile];
  }
}

- (void)createNewTile
{
  self.currentTile = nil;
  [self.currentTileLayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
  self.currentTileLayers = nil;

  self.currentTile = [SERMintrisTile newTile];
  self.currentTile.positionX = kBoardWidth / 2;
  self.currentTile.positionY = -1; // we advance it immediately into it's starting position and make collision checks
}

- (void)drawTile
{
  [self.currentTileLayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
  NSSet *parts = [self.currentTile parts];

  NSMutableSet *newTileLayers = [NSMutableSet setWithCapacity:[parts count]];
  
  for (NSArray *part in parts)
  {
    NSInteger x = [[part firstObject] integerValue] + self.currentTile.positionX;
    NSInteger y = [[part lastObject] integerValue] + self.currentTile.positionY;
    
    if (y < 0)
      continue;
    
    CAShapeLayer *layer = [self createShapeLayerForX:x y:y color:self.currentTile.color];
    [newTileLayers addObject:layer];
    [self.gameView.layer addSublayer:layer];
  }
  
  self.currentTileLayers = newTileLayers;
}

- (BOOL)isValidPositionForTile:(SERMintrisTile *)tile
{
  NSInteger x = self.currentTile.positionX;
  NSInteger y = self.currentTile.positionY;
  
  return [self isValidPositionForTile:tile x:x y:y];
}

- (BOOL)isValidPositionForTile:(SERMintrisTile *)tile x:(NSInteger)x y:(NSInteger)y
{
  NSSet *parts = [tile parts];
  
  BOOL isValid = YES;
  for (NSArray *part in parts)
  {
    NSInteger partX = [[part firstObject] integerValue] + x;
    NSInteger partY = [[part lastObject] integerValue] + y;
    
    if (partX < 0 || partX >= kBoardWidth)
    {
      isValid = NO;
      break;
    }
    
    if (partY >= (NSInteger)kBoardHeight)
    {
      isValid = NO;
      break;
    }
    
    if (partY < 0)
    {
      continue;
    }
    
    if (_matrix[partY][partX] != SERMintrisEmpty)
    {
      isValid = NO;
      break;
    }
  }
  
  return isValid;
}

- (NSInteger)checkAndClearRowsFromIndex:(NSInteger)largestRowIndex
{
  NSInteger rowIndex = largestRowIndex;
  NSInteger numberOfRowsClearedinThisTurn = 0;
  
  while (rowIndex >= 0)
  {
    // find out if this row is full
    BOOL rowFull = YES;
    for (NSInteger x = 0; x < kBoardWidth && rowFull; ++x)
    {
      rowFull &= (_matrix[rowIndex][x] != SERMintrisEmpty);
    }
  
    if (!rowFull)
    {
      // skip to next row
      --rowIndex;
      continue;
    }
    
    ++numberOfRowsClearedinThisTurn;
    
    for (NSInteger y = rowIndex; y >= 0; --y)
    {
      if (y == 0)
      {
        // top row, let's just empty it
        for (NSInteger x = 0; x < kBoardWidth; ++x)
          _matrix[y][x] = SERMintrisEmpty;
      }
      else
      {
        // copy contents from row above
        for (NSInteger x = 0; x < kBoardWidth; ++x)
          _matrix[y][x] = _matrix[y - 1][x];
      }
    }
  }
  
  return numberOfRowsClearedinThisTurn;
}

- (void)checkLevelUp:(NSInteger)numberOfRowsClearedinThisTurn
{
  if (numberOfRowsClearedinThisTurn > 0)
  {
    NSInteger previousNoOfRowsCleared = self.noOfRowsCleared;

    self.noOfRowsCleared += numberOfRowsClearedinThisTurn;

    self.statusLabel.text = [NSString stringWithFormat:@"%ld %@ cleared!", (long)self.noOfRowsCleared, self.noOfRowsCleared == 1 ? @"row" : @"rows"];
    if (self.noOfRowsCleared / 5 > previousNoOfRowsCleared / 5)
    {
      [self levelUp];
    }
  }
}

@end
