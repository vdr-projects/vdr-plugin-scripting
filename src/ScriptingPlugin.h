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

#ifndef __RUBYPLUGIN_H
#define __RUBYPLUGIN_H

#include <vdr/plugin.h>
#include <ruby.h>
#include "Version.h"
#include "PluginManager.h"

static const char *DESCRIPTION    = "A plug-in allowing to write sub-plug-ins in a dynamic language";
static const char *MAINMENUENTRY  = "Script Plug-ins";

class ScriptingPlugin : public cPlugin
{
    private:
        PluginManager* _pluginManager;

    public:
        ScriptingPlugin();
        virtual ~ScriptingPlugin();
        virtual const char *Version() { return VERSION; }
        virtual const char *Description() { return DESCRIPTION; }
        virtual const char *CommandLineHelp();
        virtual bool ProcessArgs(int argc, char *argv[]);
        virtual bool Initialize();
        virtual bool Start();
        virtual void Stop();
        virtual void Housekeeping();
        virtual void MainThreadHook();
        virtual cString Active();
        virtual time_t WakeupTime();
        virtual const char *MainMenuEntry() { return MAINMENUENTRY; }
        virtual cOsdObject *MainMenuAction();
        virtual cMenuSetupPage *SetupMenu();
        virtual bool SetupParse(const char *Name, const char *Value);
        virtual bool Service(const char *Id, void *Data = NULL);
        virtual const char **SVDRPHelpPages();
        virtual cString SVDRPCommand(const char *Command, const char *Option, int &ReplyCode);

    private:
        void ForceGarbageCollect();
        bool IsRubyError(int error);
};

#endif
