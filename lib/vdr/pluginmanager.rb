#
# vdr-scripting - A plugin for the Linux Video Disk Recorder
# Copyright (c) 2009 Tobias Grimm <vdr@e-tobi.net>
#
# This program is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the
# Free Software Foundation; either version 2 of the License, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License along with
# this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
#
#

require 'vdr/osd'

module Vdr
  PLUGINS = []
  class PluginManager < Vdr::Swig::PluginManager
    @@plugin_directory = File.expand_path(File.dirname(__FILE__) + '/../../plugins')
    def self.plugin_directory
      return @@plugin_directory
    end

    def self.plugin_directory=(directory)
      @@plugin_directory = directory
    end

    def initialize
      super
      load_plugins
    end

    def load_plugins
      for pluginFile in Dir[@@plugin_directory + '/*.rb']
        Kernel::load(pluginFile, true)
      end
    end

    def plugin_menu
      menu = Vdr::Osd::Menu.new('Script Plug-ins')
      for plugin in PLUGINS
        for mainMenuEntry, context in plugin.main_menu_entries
          item = Vdr::Osd::Item.new(mainMenuEntry)
          item.context = {:plugin => plugin, :context => context}
          item.on_select do |selected_item|
            sub_menu = selected_item.context[:plugin].invoke_menu_item(selected_item.context[:context])
            if (sub_menu)
              menu.open_sub_menu(sub_menu)
            end
          end
          menu.add_item(item)
        end
      end
      return menu
    end
  end
end
