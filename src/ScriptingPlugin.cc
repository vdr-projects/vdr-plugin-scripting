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

#include <ruby.h>

#include "ScriptingPlugin.h"
#include <vdr/tools.h>
#include <iostream>
#include "swigrubyrun.h"
#include "RubyObjectTracker.h"

using namespace std;

extern "C" void Init_swig();
extern RubyObjectTracker rubyObjectTracker;

VALUE require_pluginmanager_wrap(VALUE arg)
{
    return rb_require("vdr/pluginmanager");
}

VALUE new_pluginmanager_wrap(VALUE arg)
{
    VALUE module = rb_const_get(rb_cObject, rb_intern("Vdr"));
    VALUE klass = rb_const_get(module, rb_intern("PluginManager"));
    return rb_class_new_instance(0 ,0, klass);
}

ScriptingPlugin::ScriptingPlugin()
{
    // Initialize any member variables here.
    // DON'T DO ANYTHING ELSE THAT MAY HAVE SIDE EFFECTS, REQUIRE GLOBAL
    // VDR OBJECTS TO EXIST OR PRODUCE ANY OUTPUT!
}

ScriptingPlugin::~ScriptingPlugin()
{
      ruby_finalize();
}

const char *ScriptingPlugin::CommandLineHelp()
{
    // Return a string that describes all known command line options.
    return NULL;
}

bool ScriptingPlugin::ProcessArgs(int argc, char *argv[])
{
    // Implement command line argument processing here if applicable.
    return true;
}

bool ScriptingPlugin::Initialize()
{
    // Initialize any background activities the plugin shall perform.

    const char* configDir = cPlugin::ConfigDirectory(Name());

    RUBY_INIT_STACK;
    ruby_init();
    ruby_init_loadpath();
    ruby_incpush(cString::sprintf("%s/lib", configDir));
    ruby_script("vdr-plugin-ruby");
    Init_swig();

    rb_eval_string("STDERR.puts $LOAD_PATH");

    int error;
    VALUE result = rb_protect(require_pluginmanager_wrap, 0, &error);
    if (IsRubyError(error))
    {
        return true;
    }

    //rb_require("vdr/pluginmanager");

    VALUE rbPluginManager = rb_protect(new_pluginmanager_wrap, 0, &error);
    if (IsRubyError(error))
    {
        return true;
    }

    if (rbPluginManager == Qnil)
    {
        cerr << "rbPluginManger is nil" << endl;
    }

    Data_Get_Struct(rbPluginManager, PluginManager, _pluginManager);

    if (!_pluginManager)
    {
        cerr << "no plugin manager" << endl;
    }

    return true;
}

bool ScriptingPlugin::Start()
{
    // Start any background activities the plugin shall perform.
    return true;
}

void ScriptingPlugin::Stop()
{
    // Stop any background activities the plugin is performing.
}

void ScriptingPlugin::Housekeeping()
{
    VALUE gc_wrap(VALUE arg);
    // Perform any cleanup or other regular tasks.
}

void ScriptingPlugin::MainThreadHook()
{
    // Perform actions in the context of the main program thread.
    // WARNING: Use with great care - see PLUGINS.html!
}

cString ScriptingPlugin::Active()
{
    // Return a message string if shutdown should be postponed
    return NULL;
}

time_t ScriptingPlugin::WakeupTime()
{
    // Return custom wakeup time for shutdown script
    return 0;
}

cOsdObject *ScriptingPlugin::MainMenuAction()
{
    if (!_pluginManager)
    {
        cerr << "NO PLUGINMANAGER" << endl;
        return NULL;
    }

    cOsdObject* osdObject = _pluginManager->PluginMenu();

    if (!osdObject)
    {
        cerr << "NO MENU" << endl;
        return NULL;
    }

    rubyObjectTracker.KeepRubyObjectAlive(osdObject);
    return osdObject;
}

cMenuSetupPage *ScriptingPlugin::SetupMenu()
{
    // Return a setup menu in case the plugin supports one.
    return NULL;
}

bool ScriptingPlugin::SetupParse(const char *Name, const char *Value)
{
    // Parse your own setup parameters and store their values.
    return false;
}

bool ScriptingPlugin::Service(const char *Id, void *Data)
{
    // Handle custom service requests from other plugins
    return false;
}

const char **ScriptingPlugin::SVDRPHelpPages()
{
    // Return help text for SVDRP commands this plugin implements
    return NULL;
}

cString ScriptingPlugin::SVDRPCommand(const char *Command, const char *Option, int &ReplyCode)
{
    // Process SVDRP commands this plugin implements
    return NULL;
}


VALUE gc_wrap(VALUE arg)
{
    rb_gc();
    return Qnil;
}

void ScriptingPlugin::ForceGarbageCollect()
{
    int status;
    rb_protect(gc_wrap, 0, &status);
//    IsRubyError(status);
}


bool ScriptingPlugin::IsRubyError(int error)
{
    if (error)
    {
        VALUE lasterr = rb_gv_get("$!");

        VALUE klass = rb_class_path(CLASS_OF(lasterr));
        cerr << "class = " << RSTRING(klass)->ptr << endl;

        VALUE message = rb_obj_as_string(lasterr);
        cerr << "message = " << RSTRING(message)->ptr << endl;

        return true;
    }
    else
    {
        return false;
    }
}

VDRPLUGINCREATOR(ScriptingPlugin); // Don't touch this!
