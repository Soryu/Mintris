//
//  SERMintrisColor.h
//  Mintris
//
//  Created by Stanley Rost on 15.09.13.
//  Copyright (c) 2013 Stanley Rost. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SERMintrisColorType) {
  SERMintrisEmpty,
  SERMintrisColor1,
  SERMintrisColor2,
  SERMintrisColor3,
  SERMintrisColor4,
  SERMintrisColor5,
  SERMintrisColor6,
  SERMintrisColor7
};

@interface SERMintrisColor : NSObject

+ (UIColor *)colorForColor:(SERMintrisColorType)color;

@end
