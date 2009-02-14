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

%include "eKeys.i"
%include "eOSState.i"
%include "typemaps.i"

%{
#include <vdr/osdbase.h>
%}

%feature("director") cOsdMenu;

//
// When adding an item to a menu, the menu becomes it's owner and is
// responsible for deleting it.
//
%apply SWIGTYPE* TRANSFER_DELETE_RESPONSIBILITY {cOsdItem* foo};

//
// When adding an submenu to a menu, the menu becomes it's owner and is
// responsible for deleting it.
//
%apply SWIGTYPE* TRANSFER_DELETE_RESPONSIBILITY {cOsdMenu* foo};

class cOsdMenu
{
    protected:
        eOSState AddSubMenu(cOsdMenu *SubMenu);

    public:
        cOsdMenu(const char *Title, int c0 = 0, int c1 = 0, int c2 = 0, int c3 = 0, int c4 = 0);
        virtual ~cOsdMenu();
        int Current(void) const;
        void Add(cOsdItem *Item, bool Current = false, cOsdItem *After = NULL);
        void Ins(cOsdItem *Item, bool Current = false, cOsdItem *Before = NULL);
        virtual eOSState ProcessKey(eKeys Key);
};
