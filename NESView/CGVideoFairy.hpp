//
//  CGVideoFaily.hpp
//  NESView
//
//  Created by 鈴木　洋司　 on 2018/02/28.
//  Copyright © 2018年 SUZUKI PLAN. All rights reserved.
//

#ifndef CGVideoFaily_hpp
#define CGVideoFaily_hpp

#include "Cycloa/src/emulator/fairy/VideoFairy.h"
#include <stdio.h>

class CGVideoFairy : public VideoFairy {
public:
  bool rendered;
  unsigned short bitmap565[screenWidth * screenHeight];
  CGVideoFairy();
  ~CGVideoFairy();
  void dispatchRendering(const uint8_t(&nesBuffer)[screenHeight][screenWidth],
                         const uint8_t paletteMask);
};

#endif /* CGVideoFaily_hpp */
