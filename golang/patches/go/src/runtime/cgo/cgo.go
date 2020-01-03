// Copyright 2010 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

/*
Package cgo contains runtime support for code generated
by the cgo tool.  See the documentation for the cgo command
for details on using cgo.
*/
package cgo

/*

#cgo darwin,!arm,!arm64 LDFLAGS: -lpthread
#cgo darwin,arm LDFLAGS: -framework CoreFoundation -isysroot /usr/share/SDKs/iPhoneOS.sdk -F/System/Library/Frameworks -miphoneos-version-min=7.0 -arch armv7 -L/usr/lib -L/usr/local/lib
#cgo darwin,arm CFLAGS: -framework CoreFoundation -isysroot /usr/share/SDKs/iPhoneOS.sdk -F/System/Library/Frameworks -miphoneos-version-min=7.0 -arch armv7 -I/usr/include -I/usr/local/include -Wno-unused-command-line-argument
#cgo darwin,arm64 LDFLAGS: -framework CoreFoundation -isysroot /usr/share/SDKs/iPhoneOS.sdk -F/System/Library/Frameworks -miphoneos-version-min=7.0 -arch arm64 -L/usr/lib -L/usr/local/lib
#cgo darwin,arm64 CFLAGS: -framework CoreFoundation -isysroot /usr/share/SDKs/iPhoneOS.sdk -F/System/Library/Frameworks -miphoneos-version-min=7.0 -arch arm64 -I/usr/include -I/usr/local/include -Wno-unused-command-line-argument
#cgo dragonfly LDFLAGS: -lpthread
#cgo freebsd LDFLAGS: -lpthread
#cgo android LDFLAGS: -llog
#cgo !android,linux LDFLAGS: -lpthread
#cgo netbsd LDFLAGS: -lpthread
#cgo openbsd LDFLAGS: -lpthread
#cgo aix LDFLAGS: -Wl,-berok
#cgo solaris LDFLAGS: -lxnet

#cgo CFLAGS: -Wall -Werror

#cgo solaris CPPFLAGS: -D_POSIX_PTHREAD_SEMANTICS

*/
import "C"
