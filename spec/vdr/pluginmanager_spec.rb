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

require  File.expand_path(File.dirname(__FILE__) + '/../helper')
require 'vdr/pluginmanager'
require 'pathname'

describe Vdr::PluginManager do
  before(:each) do
    Vdr::PLUGINS.clear
    Vdr::PluginManager::plugin_directory = File.dirname(__FILE__) + '/_sample-plugins'
    @pluginManager = Vdr::PluginManager.new
  end
  
  describe 'when loading a plugin throws an exception' do
    it 'should log the exception'
    it 'should not load the plugin'  
  end

  describe 'when created' do
    it 'should load all plugins in the plugin directory' do
      Vdr::PLUGINS.should have(2).things 
    end
    
    it 'should provide a menu containing the main menu entries of all plugins' do
      menu = @pluginManager.plugin_menu
      menu[0].text.should == "plugin 1.a"
      menu[1].text.should == "plugin 1.b"
      menu[2].text.should == "plugin 2.a"
      menu[3].text.should == "plugin 2.b"
    end
  end

  describe 'when selecting an item' do
    before(:each) do
      @menu = @pluginManager.plugin_menu
    end
    
    it 'should inform the plugin' do
      Vdr::PLUGINS[0].should_receive(:invoke_menu_item).with(:a)
      Vdr::PLUGINS[1].should_receive(:invoke_menu_item).with(:b)
      @menu[0].process_key(Vdr::Swig::KOk)
      @menu[3].process_key(Vdr::Swig::KOk)
    end
  
    it 'should switch to the menu eventually provided by the plugin' do
      returned_menu = Vdr::Osd::Menu.new
      Vdr::PLUGINS[1].stub!(:invoke_menu_item).and_return(returned_menu)
      @menu.should_receive(:open_sub_menu).with(returned_menu)
      @menu[2].process_key(Vdr::Swig::KOk)
    end
  end
end
