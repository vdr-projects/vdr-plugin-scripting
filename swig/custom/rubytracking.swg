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

#include "src/RubyObjectTracker.h"

RubyObjectTracker rubyObjectTracker;

#ifdef __cplusplus
extern "C" {
#endif

SWIGRUNTIME void SWIG_RubyInitializeTrackings(void)
{
    VALUE rubyObjectTrackerClass = rb_define_class_under(_mSWIG, "RubyObjectTrackings", rb_cObject);

    // The object tracker is allocated on the stack, so no free function is needed.
    // But a mark function is required to keep the tracked ruby objects alive
    VALUE rbRubyObjectTracker = Data_Wrap_Struct(rubyObjectTrackerClass, RubyObjectTracker::MarkTrackedRubyObjects, 0,
      &rubyObjectTracker);

    // To keep the RubyObjectTracker alive itself, put it into a variable under the SWIG module:
    VALUE rubyObjectTrackerSymbol = rb_intern("@ruby_object_tracker");
    rb_ivar_set(_mSWIG, rubyObjectTrackerSymbol, rbRubyObjectTracker);
}

SWIGRUNTIME void SWIG_RubyAddTracking(void* ptr, VALUE object)
{
  rubyObjectTracker.Track(ptr, object);
}

SWIGRUNTIME VALUE SWIG_RubyInstanceFor(void* ptr)
{
  return rubyObjectTracker.GetTrackedRubyObject(ptr);
}

SWIGRUNTIME void SWIG_RubyRemoveTracking(void* ptr)
{
  rubyObjectTracker.Untrack(ptr);
}

SWIGRUNTIME void SWIG_RubyUnlinkObjects(void* ptr)
{
  VALUE object = SWIG_RubyInstanceFor(ptr);

  if (object != Qnil) {
    DATA_PTR(object) = 0;
  }
}

#ifdef __cplusplus
}
#endif
