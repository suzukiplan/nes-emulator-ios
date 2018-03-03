//
//  NESEmulator.cpp
//  NESView
//
//  Created by 鈴木　洋司　 on 2018/02/26.
//  Copyright © 2018年 SUZUKI PLAN. All rights reserved.
//

#include <pthread.h>
#include "ALAudioFairy.hpp"
#include "CGVideoFairy.hpp"
#include "NESEmulator.h"
#include "VGamepadFairy.hpp"
#include "Cycloa/src/emulator/VirtualMachine.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Weverything"
#include "miniz.h"
#pragma clang diagnostic pop

struct Context {
    pthread_mutex_t mutex;
    VideoFairy* video;
    AudioFairy* audio;
    GamepadFairy* pad1;
    GamepadFairy* pad2;
    VirtualMachine* vm;
    uint8_t* rom;
    uint32_t romSize;
    volatile bool loaded;
    unsigned short vram[256 * 240];
};

void* NESEmulator_init()
{
    struct Context* result;
    result = (struct Context*)malloc(sizeof(struct Context));
    if (!result) {
        return NULL;
    }
    memset(result, 0, sizeof(struct Context));
    try {
        result->video = new CGVideoFairy();
        result->audio = new ALAudioFairy();
        result->pad1 = new VGamepadFairy();
        result->pad2 = new VGamepadFairy();
        result->vm = new VirtualMachine(*result->video, *result->audio,
                                        result->pad1, result->pad2);
    } catch (...) {
        NESEmulator_deinit(result);
        return NULL;
    }
    pthread_mutex_init(&result->mutex, NULL);
    return result;
}

void NESEmulator_deinit(void* context)
{
    struct Context* c = (struct Context*)context;
    if (c->vm)
        delete c->vm;
    if (c->pad2)
        delete c->pad2;
    if (c->pad1)
        delete c->pad1;
    if (c->audio)
        delete c->audio;
    if (c->video)
        delete c->video;
    if (c->rom)
        free(c->rom);
    pthread_mutex_destroy(&c->mutex);
    free(context);
}

int NESEmulator_loadRom(void* context, const void* rom, size_t size)
{
    struct Context* c = (struct Context*)context;
    c->loaded = false;
    if (c->rom)
        free(c->rom);
    c->rom = (uint8_t*)malloc(size);
    c->romSize = (uint32_t)size;
    if (NULL == c->rom)
        return false;
    memcpy(c->rom, rom, size);
    c->vm->loadCartridge(c->rom, c->romSize);
    c->vm->sendHardReset();
    c->loaded = true;
    return true;
}

void NESEmulator_execFrame(void* context, int keyP1, int keyP2)
{
    struct Context* c = (struct Context*)context;
    if (!c->loaded) {
        return;
    }
    ((VGamepadFairy*)c->pad1)->code = keyP1;
    ((VGamepadFairy*)c->pad2)->code = keyP2;
    ((CGVideoFairy*)c->video)->rendered = false;
    while (!((CGVideoFairy*)c->video)->rendered)
        c->vm->run();
    pthread_mutex_lock(&c->mutex);
    memcpy(c->vram, ((CGVideoFairy*)c->video)->bitmap565, sizeof(c->vram));
    pthread_mutex_unlock(&c->mutex);
}

void NESEmulator_skipFrame(void* context, int keyP1, int keyP2)
{
    struct Context* c = (struct Context*)context;
    if (!c->loaded) {
        return;
    }
    ((VGamepadFairy*)c->pad1)->code = keyP1;
    ((VGamepadFairy*)c->pad2)->code = keyP2;
    ((CGVideoFairy*)c->video)->rendered = false;
    while (!((CGVideoFairy*)c->video)->rendered)
        c->vm->run();
}

void NESEmulator_copyVram(void* context, void* copyTo)
{
    struct Context* c = (struct Context*)context;
    pthread_mutex_lock(&c->mutex);
    memcpy(copyTo, c->vram, sizeof(c->vram));
    pthread_mutex_unlock(&c->mutex);
}

void NESEmulator_reset(void* context)
{
    ((struct Context*)context)->vm->sendHardReset();
}

int NESEmulator_getDump(void* context, void* dump, size_t* size) { return -1; }

int NESEmulator_setDump(void* context, const void* dump, size_t size)
{
    return -1;
}
