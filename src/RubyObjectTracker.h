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

#ifndef __RUBY_OBJECT_TRACKER_H
#define __RUBY_OBJECT_TRACKER_H

#include<map>
#include<ruby.h>

class TrackedRubyObject
{
    private:
        VALUE _rubyObject;
        bool _keepAlive;

    public:
        TrackedRubyObject();
        TrackedRubyObject(VALUE rubyObject, bool keepAlive);
        VALUE RubyObject();
        void KeepAlive(bool keepAlive);
        void Mark();
};

class RubyObjectTracker
{
    private:
        std::map<void*, TrackedRubyObject> _map;

    public:
        void Track(void* cppPointer, VALUE rubyObject);
        void Untrack(void* cppPointer);
        VALUE GetTrackedRubyObject(void* cppPointer);
        void KeepRubyObjectAlive(void* cppPointer);
        void MarkTrackedRubyObjects();
        static void MarkTrackedRubyObjects(void* self);
};

#endif
