//
//  VGamePad.hpp
//  NESView
//
//  Created by 鈴木　洋司　 on 2018/02/28.
//  Copyright © 2018年 SUZUKI PLAN. All rights reserved.
//

#ifndef VGamePad_h
#define VGamePad_h

#include "Cycloa/src/emulator/fairy/GamepadFairy.h"
#include <stdio.h>

class VGamepadFairy : public GamepadFairy {
public:
  int code;

  VGamepadFairy() { code = 0; }

  ~VGamepadFairy() {}

  void onVBlank() {}

  void onUpdate() {}

  bool isPressed(uint8_t keyIdx) {
    switch (keyIdx) {
    case A:
      return code & MASK_A;
    case B:
      return code & MASK_B;
    case START:
      return code & MASK_START;
    case SELECT:
      return code & MASK_SELECT;
    case UP:
      return code & MASK_UP;
    case DOWN:
      return code & MASK_DOWN;
    case LEFT:
      return code & MASK_LEFT;
    case RIGHT:
      return code & MASK_RIGHT;
    }
    return false;
  }
};

#endif /* VGamePad_h */
