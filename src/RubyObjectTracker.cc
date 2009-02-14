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

#include "RubyObjectTracker.h"

#ifdef DEBUG_RUBY_OBJECT_TRACKER
#include <iostream>
#endif

using namespace std;

TrackedRubyObject::TrackedRubyObject()
  :_rubyObject(Qnil), _keepAlive(false)
{
}

TrackedRubyObject::TrackedRubyObject(VALUE rubyObject, bool keepAlive)
  :_rubyObject(rubyObject), _keepAlive(keepAlive)
{
}

VALUE TrackedRubyObject::RubyObject()
{
    return _rubyObject;
}

void TrackedRubyObject::KeepAlive(bool keepAlive)
{
    _keepAlive = keepAlive;
}

void TrackedRubyObject::Mark()
{
    if (_keepAlive)
    {
#ifdef DEBUG_RUBY_OBJECT_TRACKER
        cerr << "RubyObjectTracker::Mark(" << _rubyObject << ")" << endl;
#endif
        rb_gc_mark(_rubyObject);
    }
}

void RubyObjectTracker::Track(void* cppPointer, VALUE rubyObject)
{
#ifdef DEBUG_RUBY_OBJECT_TRACKER
    cerr << "RubyObjectTracker::Track(" << rubyObject << ")" << endl;
#endif
    _map[cppPointer] = TrackedRubyObject(rubyObject, false);
}

void RubyObjectTracker::Untrack(void* cppPointer)
{
#ifdef DEBUG_RUBY_OBJECT_TRACKER
    map<void*, TrackedRubyObject>::iterator i = _map.find(cppPointer);
    if (i != _map.end())
    {
        cerr << "RubyObjectTracker::Untrack(" << i->second.RubyObject() << ")" << endl;
    }
#endif
    _map.erase(cppPointer);
}

VALUE RubyObjectTracker::GetTrackedRubyObject(void* cppPointer)
{
    if (_map.find(cppPointer) == _map.end())
    {
        return Qnil;
    }
    else
    {
        return _map.find(cppPointer)->second.RubyObject();
    }
}

void RubyObjectTracker::KeepRubyObjectAlive(void* cppPointer)
{
    map<void*, TrackedRubyObject>::iterator i = _map.find(cppPointer);
    if (i != _map.end())
    {
        i->second.KeepAlive(true);
    }
}

void RubyObjectTracker::MarkTrackedRubyObjects()
{
    for ( map<void*, TrackedRubyObject>::iterator i = _map.begin() ; i != _map.end(); i++ )
    {
        i->second.Mark();
    }
}

void RubyObjectTracker::MarkTrackedRubyObjects(void* self)
{
    ((RubyObjectTracker*) self)->MarkTrackedRubyObjects();
}
