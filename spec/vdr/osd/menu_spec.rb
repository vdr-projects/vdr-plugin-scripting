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

require  File.expand_path(File.dirname(__FILE__) + '/../../helper')
require 'vdr/osd'

describe Vdr::Osd::Menu do
  before(:each) do
    @menu = Vdr::Osd::Menu.new('Title')
  end

  describe 'when creating' do
    it 'should set the menu title' do
      @menu.title.should == 'Title'
      @menu.cosdmenu_ctor_arguments[0].should == 'Title' 
    end
    
    it 'should configure the menu' do
      menu = Vdr::Osd::Menu.new do |m|
        m.title = 'new title'
      end
      menu.title.should == 'new title'
    end
  end

  it 'should set the menu title' do
    @menu.should_receive(:set_title).with('NewTitle') 
    @menu.title='NewTitle'
    @menu.title.should == 'NewTitle'
  end

  it 'should add an item to the menu' do
    item = Vdr::Osd::Item.new
    @menu.should_receive(:add).with(item)
    @menu.add_item(item)
  end

  it 'should provide a list of menu items' do
    item1 = Vdr::Osd::Item.new
    item2 = Vdr::Osd::Item.new
    @menu.add_item(item1)
    @menu.add_item(item2)
    @menu[0].should == item1
    @menu[1].should == item2
  end

  it 'should add a sub menu when opening a sub menu' do
    sub_menu = Vdr::Osd::Menu.new
    @menu.should_receive(:add_sub_menu).with(sub_menu)
    @menu.open_sub_menu(sub_menu)
  end 
 
  it 'should return the parents result from process_key' do
    @menu.fake_process_key(Vdr::Swig::KOk).should == Vdr::Swig::OsUnknown
  end

  it 'should return OsBack from process_key when requesting to close the menu' do
    @menu.close
    @menu.fake_process_key(Vdr::Swig::KOk).should == Vdr::Swig::OsBack
  end

  it 'should return OsEnd from process_key when requesting to close all menus' do
    @menu.close_all
    @menu.fake_process_key(Vdr::Swig::KOk).should == Vdr::Swig::OsEnd
  end
  
  it 'should add a new menu item' do
    @menu.add_new_item('item')
    @menu[0].text.should == 'item'
  end

  it 'should set the color help texts' do
    @menu.red_help = 'Red'
    @menu.COsdMenu_help_texts.should == ['Red', nil, nil, nil] 

    @menu.green_help = 'Green'
    @menu.COsdMenu_help_texts.should == ['Red', 'Green', nil, nil] 

    @menu.yellow_help = 'Yellow'
    @menu.COsdMenu_help_texts.should == ['Red', 'Green', 'Yellow', nil] 

    @menu.blue_help = 'Blue'
    @menu.COsdMenu_help_texts.should == ['Red', 'Green', 'Yellow', 'Blue'] 
  end

  it 'should trigger the on_keypress event when a key is pressed' do
    pressed_key = nil
    @menu.on_keypress do |key|
      pressed_key = key
    end
    @menu.fake_process_key(Vdr::Swig::KRed)
    pressed_key.should == :key_red
  end

  it 'should trigger the on_keypress event when a specific key is pressed' do
    red_key_pressed = false
    @menu.on_keypress(:key_red) do
      red_key_pressed = true
    end
    @menu.fake_process_key(Vdr::Swig::KGreen)
    red_key_pressed.should == false
    @menu.fake_process_key(Vdr::Swig::KRed)
    red_key_pressed.should == true
  end
  
  it 'should clear the menu' do
    @menu.clear
    @menu.COsdMenu_cleared.should == true
  end
  
  it 'should redisplay the menu when refreshing' do
    @menu.should_receive(:display)
    @menu.refresh
  end
end
