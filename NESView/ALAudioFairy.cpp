//
//  ALAudioFaily.cpp
//  NESView
//
//  Created by 鈴木　洋司　 on 2018/02/28.
//  Copyright © 2018年 SUZUKI PLAN. All rights reserved.
//

#include "ALAudioFairy.hpp"

#define SAMPLING_FORMAT AL_FORMAT_MONO16
#define SAMPLING_RATE 44100

static void* sound_thread(void* context)
{
    ALAudioFairy* c = (ALAudioFairy*)context;
    ALint st;
    char buffer[16384];
    short skipBuffer[4096];
    int size;

    memset(buffer, 0, sizeof(buffer));

    // バッファリングループ
    while (c->alive) {
        alGetSourcei(c->sndASrc, AL_BUFFERS_QUEUED, &st);
        if (st < BUFNUM) {
            alGenBuffers(1, &c->sndABuf);
        } else {
            alGetSourcei(c->sndASrc, AL_SOURCE_STATE, &st);
            if (st != AL_PLAYING) {
                alSourcePlay(c->sndASrc);
            }
            while (static_cast<void>(
                       alGetSourcei(c->sndASrc, AL_BUFFERS_PROCESSED, &st)),
                   st == 0) {
                usleep(1000);
            }
            alSourceUnqueueBuffers(c->sndASrc, 1, &c->sndABuf);
            alDeleteBuffers(1, &c->sndABuf);
            alGenBuffers(1, &c->sndABuf);
        }
        size = (int)sizeof(buffer);
        c->buffering(buffer, &size);
        int speed = c->speed;
        if (speed < 2) {
            alBufferData(c->sndABuf, SAMPLING_FORMAT, buffer, size, SAMPLING_RATE);
        } else {
            int shrinkedSize = 0;
            for (int i = 0; i < size / 2; i += speed, shrinkedSize++) {
                skipBuffer[shrinkedSize] = ((short*)buffer)[i];
            }
            alBufferData(c->sndABuf, SAMPLING_FORMAT, skipBuffer, shrinkedSize * 2, SAMPLING_RATE);
        }
        alSourceQueueBuffers(c->sndASrc, 1, &c->sndABuf);
    }

    // 止まるまで待つ（※再生中に解放するとクラッシュするので）
    do {
        usleep(1000);
        alGetSourcei(c->sndASrc, AL_SOURCE_STATE, &st);
    } while (st == AL_PLAYING);

    return NULL;
}

ALAudioFairy::ALAudioFairy()
{
    alive = false;
    sndDev = NULL;
    sndCtx = NULL;
    sndABuf = 0;
    sndASrc = 0;
    speed = 1;
    alBufferDataStaticProc = NULL;
    pthread_mutex_init(&mutex, NULL);
    if (!initAL()) {
        throw new EmulatorException("Cannot initialize OpenAL.");
    }
}

ALAudioFairy::~ALAudioFairy()
{
    termAL();
    pthread_mutex_destroy(&mutex);
}

void ALAudioFairy::lock() { pthread_mutex_lock(&mutex); }

void ALAudioFairy::unlock() { pthread_mutex_unlock(&mutex); }

bool ALAudioFairy::initAL()
{
    sndDev = alcOpenDevice(NULL);
    if (NULL == sndDev) {
        return false;
    }
    sndCtx = alcCreateContext(sndDev, NULL);
    if (NULL == sndCtx) {
        return false;
    }
    if (!alcMakeContextCurrent(sndCtx)) {
        return false;
    }
    alBufferDataStaticProc = (alBufferDataStaticProcPtr)alcGetProcAddress(
        NULL, (const ALCchar*)"alBufferDataStatic");
    alGenSources(1, &sndASrc);

    alive = true;
    if (-1 == pthread_create(&tid, NULL, sound_thread, this)) {
        alive = false;
        return false;
    }
    return true;
}

void ALAudioFairy::buffering(void* b, int* size)
{
    // Cycloaがバッファリングしたデータをpop
    const int maxLen = *size / 2;
    int16_t* buffer = (int16_t*)b;
    int copiedLength = popAudio(buffer, maxLen);

    // バッファリングしたサイズが小さすぎるとptptするので 1k (2KB)
    // は溜まるまで待つ
    while (alive && copiedLength < 1024) {
        usleep(100);
        copiedLength += popAudio(buffer + copiedLength, maxLen - copiedLength);
    }

    // サイズをコピーしたサイズに更新
    *size = copiedLength * 2;
}

void ALAudioFairy::termAL()
{
    if (alive) {
        alive = false;
        pthread_join(tid, NULL);
    }
    if (sndCtx) {
        alcDestroyContext(sndCtx);
        sndCtx = NULL;
    }
    if (sndDev) {
        alcCloseDevice(sndDev);
        sndDev = NULL;
    }
}
