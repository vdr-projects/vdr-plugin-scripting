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

include Vdr::Osd

class MyPlugin
  def main_menu_entries
    [
      ['Greet The World', Proc.new { greet_the_world }],
      ['Greet The Universe', Proc.new { greet_the_universe }],
      ['Greet Your Favorite Starship Captain', Proc.new { select_a_starship_captain }]
    ]
  end

  def invoke_menu_item(proc)
    return proc.call
  end

  def greet_the_world
    OsdMessage.Show("Hello World!", 3);
    nil
  end

  def greet_the_universe
    OsdMessage.Show("Hello Universe!", 3);
    nil
  end

  CAPTAINS =
  [
    {:name => 'Picard',  :first_name => 'Jean Luc'},
    {:name => 'Janeway', :first_name => 'Kathryn'},
    {:name => 'Sisko',   :first_name => 'Benjamin'},
    {:name => 'Archer',  :first_name => 'Jonathan'},
    {:name => 'Solo',    :first_name => 'Han'},
    {:name => 'Leela',   :first_name => 'Turange'},
    {:name => 'Future',  :first_name => 'Curtis'}
  ]

  def select_a_starship_captain
    return Menu.new("Select your favorit starship captain") do |menu|
      for captain in CAPTAINS
        item = menu.add_new_item("Captain #{captain[:name]}")
        item.context = captain
        item.on_select do |cpt|
          OsdMessage.Show("Hello #{cpt.context[:first_name]}!!!")
          menu.close
        end
      end
    end
  end
end

Vdr::PLUGINS << MyPlugin.new
