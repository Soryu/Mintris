//
//  SERMintrisColor.m
//  Mintris
//
//  Created by Stanley Rost on 15.09.13.
//  Copyright (c) 2013 Stanley Rost. All rights reserved.
//

#import "SERMintrisColor.h"
#import "UIColor+SER.h"


@implementation SERMintrisColor

+ (UIColor *)colorForColor:(SERMintrisColorType)color
{
  NSString *colorString = @"000000";

  switch (color)
  {
    case SERMintrisColor1: colorString = @"FF0000"; break;
    case SERMintrisColor2: colorString = @"FF9400"; break;
    case SERMintrisColor3: colorString = @"FFE100"; break;
    case SERMintrisColor4: colorString = @"2CDE00"; break;
    case SERMintrisColor5: colorString = @"005DEE"; break;
    case SERMintrisColor6: colorString = @"FF009E"; break;
    case SERMintrisColor7: colorString = @"780095"; break;
    default: break;
  }
  
  return [UIColor colorFromHexString:colorString];
}

@end
