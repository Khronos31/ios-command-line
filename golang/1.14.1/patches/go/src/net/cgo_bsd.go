// Copyright 2011 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// +build cgo,!netgo
// +build darwin dragonfly freebsd

package net

/*
#cgo darwin,arm LDFLAGS: -framework CoreFoundation -isysroot /usr/share/SDKs/iPhoneOS.sdk -miphoneos-version-min=7.0 -arch armv7
#cgo darwin,arm CFLAGS: -framework CoreFoundation -isysroot /usr/share/SDKs/iPhoneOS.sdk -miphoneos-version-min=7.0 -arch armv7
#cgo darwin,arm64 LDFLAGS: -framework CoreFoundation -isysroot /usr/share/SDKs/iPhoneOS.sdk -miphoneos-version-min=7.0 -arch arm64
#cgo darwin,arm64 CFLAGS: -framework CoreFoundation -isysroot /usr/share/SDKs/iPhoneOS.sdk -miphoneos-version-min=7.0 -arch arm64
#include <netdb.h>
*/
import "C"

const cgoAddrInfoFlags = (C.AI_CANONNAME | C.AI_V4MAPPED | C.AI_ALL) & C.AI_MASK
