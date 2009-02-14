/*
 * vdr-scripting - A plugin for the Linux Video Disk Recorder
 * Copyright (c) 2009 Tobias Grimm <vdr@e-tobi.net>
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation; either version 2 of the License, or (at your option)
 * any later version.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
 * details.
 *
 * You should have received a copy of the GNU General Public License along with
 * this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
 *
 */

%module vdr

%{
#include <vdr/keys.h>
%}

enum eKeys 
{
    // "Up" and "Down" must be the first two keys!
     kUp,
     kDown,
     kMenu,
     kOk,
     kBack,
     kLeft,
     kRight,
     kRed,
     kGreen,
     kYellow,
     kBlue,
     k0, k1, k2, k3, k4, k5, k6, k7, k8, k9,
     kInfo,
     kPlay,
     kPause,
     kStop,
     kRecord,
     kFastFwd,
     kFastRew,
     kNext,
     kPrev,
     kPower,
     kChanUp,
     kChanDn,
     kChanPrev,
     kVolUp,
     kVolDn,
     kMute,
     kAudio,
     kSubtitles,
     kSchedule,
     kChannels,
     kTimers,
     kRecordings,
     kSetup,
     kCommands,
     kUser1, kUser2, kUser3, kUser4, kUser5, kUser6, kUser7, kUser8, kUser9,
     kNone,
     kKbd,
     // The following codes are used internally:
     k_Plugin,
     k_Setup,
     // The following flags are OR'd with the above codes:
     k_Repeat  = 0x8000,
     k_Release = 0x4000,
     k_Flags   = k_Repeat | k_Release,
};
