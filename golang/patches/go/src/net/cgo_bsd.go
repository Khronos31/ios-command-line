// Copyright 2011 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// +build cgo,!netgo
// +build darwin dragonfly freebsd

package net

/*
#include <netdb.h>
#cgo darwin,arm LDFLAGS: -framework CoreFoundation -isysroot /usr/share/SDKs/iPhoneOS.sdk -miphoneos-version-min=7.0 -arch armv7 -L/usr/lib -L/usr/local/lib
#cgo darwin,arm CFLAGS: -framework CoreFoundation -isysroot /usr/share/SDKs/iPhoneOS.sdk -miphoneos-version-min=7.0 -arch armv7 -I/usr/include -I/usr/local/include -Wno-unused-command-line-argument
#cgo darwin,arm64 LDFLAGS: -framework CoreFoundation -isysroot /usr/share/SDKs/iPhoneOS.sdk -miphoneos-version-min=7.0 -arch arm64 -L/usr/lib -L/usr/local/lib
#cgo darwin,arm64 CFLAGS: -framework CoreFoundation -isysroot /usr/share/SDKs/iPhoneOS.sdk -miphoneos-version-min=7.0 -arch arm64 -I/usr/include -I/usr/local/include -Wno-unused-command-line-argument
*/
import "C"

const cgoAddrInfoFlags = (C.AI_CANONNAME | C.AI_V4MAPPED | C.AI_ALL) & C.AI_MASK
