//
//  NESEmulator.hpp
//  NESView
//
//  Created by 鈴木　洋司　 on 2018/02/26.
//  Copyright © 2018年 SUZUKI PLAN. All rights reserved.
//

#ifndef NESEmulator_hpp
#define NESEmulator_hpp

#include <stdio.h>

#ifdef __cplusplus
extern "C" {
#endif

void* NESEmulator_init(void);
void NESEmulator_deinit(void* context);
int NESEmulator_loadRom(void* context, const void* rom, size_t size);
void NESEmulator_execFrame(void* context, int keyCode);
void NESEmulator_copyVram(void* context, void* copyTo);
void NESEmulator_reset(void* context);
int NESEmulator_getDump(void* context, void* dump, size_t* size);
int NESEmulator_setDump(void* context, const void* dump, size_t size);

#ifdef __cplusplus
};
#endif

#endif /* NESEmulator_hpp */
