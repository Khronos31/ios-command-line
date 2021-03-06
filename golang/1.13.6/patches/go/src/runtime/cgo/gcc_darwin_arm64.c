// Copyright 2014 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

#include <limits.h>
#include <pthread.h>
#include <signal.h>
#include <string.h> /* for strerror */
#include <sys/param.h>
#include <unistd.h>
#include <stdlib.h>

#include <CoreFoundation/CFBundle.h>
#include <CoreFoundation/CFString.h>

#include "libcgo.h"
#include "libcgo_unix.h"

#define magic (0xc476c475c47957UL)

// inittls allocates a thread-local storage slot for g.
//
// It finds the first available slot using pthread_key_create and uses
// it as the offset value for runtime.tlsg.
static void
inittls(void **tlsg, void **tlsbase)
{
	pthread_key_t k;
	int i, err;

	err = pthread_key_create(&k, nil);
	if(err != 0) {
		fprintf(stderr, "runtime/cgo: pthread_key_create failed: %d\n", err);
		abort();
	}
	//fprintf(stderr, "runtime/cgo: k = %d, tlsbase = %p\n", (int)k, tlsbase); // debug
	pthread_setspecific(k, (void*)magic);
	// The first key should be at 257.
	for (i=0; i<PTHREAD_KEYS_MAX; i++) {
		if (*(tlsbase+i) == (void*)magic) {
			*tlsg = (void*)(i*sizeof(void *));
			pthread_setspecific(k, 0);
			return;
		}
	}
	fprintf(stderr, "runtime/cgo: could not find pthread key.\n");
	abort();
}

static void *threadentry(void*);
static void (*setg_gcc)(void*);

void
_cgo_sys_thread_start(ThreadStart *ts)
{
	pthread_attr_t attr;
	sigset_t ign, oset;
	pthread_t p;
	size_t size;
	int err;

	//fprintf(stderr, "runtime/cgo: _cgo_sys_thread_start: fn=%p, g=%p\n", ts->fn, ts->g); // debug
	sigfillset(&ign);
	pthread_sigmask(SIG_SETMASK, &ign, &oset);

	pthread_attr_init(&attr);
	size = 0;
	pthread_attr_getstacksize(&attr, &size);
	// Leave stacklo=0 and set stackhi=size; mstart will do the rest.
	ts->g->stackhi = size;
	err = _cgo_try_pthread_create(&p, &attr, threadentry, ts);

	pthread_sigmask(SIG_SETMASK, &oset, nil);

	if (err != 0) {
		fprintf(stderr, "runtime/cgo: pthread_create failed: %s\n", strerror(err));
		abort();
	}
}

extern void crosscall1(void (*fn)(void), void (*setg_gcc)(void*), void *g);
static void*
threadentry(void *v)
{
	ThreadStart ts;

	ts = *(ThreadStart*)v;
	free(v);

	darwin_arm_init_thread_exception_port();

	crosscall1(ts.fn, setg_gcc, (void*)ts.g);
	return nil;
}

void
x_cgo_init(G *g, void (*setg)(void*), void **tlsg, void **tlsbase)
{
	pthread_attr_t attr;
	size_t size;

	//fprintf(stderr, "x_cgo_init = %p\n", &x_cgo_init); // aid debugging in presence of ASLR
	setg_gcc = setg;
	pthread_attr_init(&attr);
	pthread_attr_getstacksize(&attr, &size);
	g->stacklo = (uintptr)&attr - size + 4096;
	pthread_attr_destroy(&attr);

	// yes, tlsbase from mrs might not be correctly aligned.
	inittls(tlsg, (void**)((uintptr)tlsbase & ~7));

	darwin_arm_init_mach_exception_handler();
	darwin_arm_init_thread_exception_port();

}
