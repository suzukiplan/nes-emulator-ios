//
//  ALAudioFaily.hpp
//  NESView
//
//  Created by 鈴木　洋司　 on 2018/02/28.
//  Copyright © 2018年 SUZUKI PLAN. All rights reserved.
//

#ifndef ALAudioFaily_hpp
#define ALAudioFaily_hpp

#include "Cycloa/src/emulator/fairy/AudioFairy.h"
#include <OpenAL/al.h>
#include <OpenAL/alc.h>
#include <pthread.h>
#include <stdio.h>
#include <unistd.h>

#define kOutputBus 0
#define kInputBus 1
#define BUFNUM 2
typedef ALvoid AL_APIENTRY (*alBufferDataStaticProcPtr)(const ALint bid, ALenum format, ALvoid* data, ALsizei size, ALsizei freq);

class ALAudioFairy : public AudioFairy
{
  public: // 以下はsound_threadから参照するのでスコープを public にしている (外部からは触ってはならない)
    ALCdevice* sndDev;
    ALCcontext* sndCtx;
    ALuint sndABuf;
    ALuint sndASrc;
    alBufferDataStaticProcPtr alBufferDataStaticProc;
    volatile bool alive;
    void buffering(void* buffer, int* size);

  private:
    pthread_mutex_t mutex;
    pthread_t tid;
    void termAL();
    bool initAL();

  public:
    ALAudioFairy();
    ~ALAudioFairy();
    void lock();
    void unlock();
};

#endif /* ALAudioFaily_hpp */
