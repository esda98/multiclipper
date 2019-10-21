/* PinManager.vala
 *
 * Copyright 2019 Erik Abramczyk
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */


using Gtk;
using Gdk;
using Gee;

namespace Multiclipper {
    public class PinManager : Object {
        static PinManager? instance;
        Clipboard defaultClip;
        HashTable<string, ArrayList<Pin>> pinCategories = new HashTable<string, ArrayList<Pin>>(str_hash, str_equal);

        PinManager() {
            defaultClip = Clipboard.get_default(Display.get_default());
        }

        public static PinManager getInstance() {
            if (instance == null) {
                instance = new PinManager();
            }
            return instance;
        }

        public bool insertNewCategory(string name) {
            if (pinCategories.get(name) != null) { return false; }
            pinCategories.insert(name, new ArrayList<Pin>());
            newCategory(name);
            return true;
        }

        public async void loadCategories() {
            //later on read from file of saved categories and pins for those categories, just do a default for now
            insertNewCategory("Default");
        }

        public signal void newCategory(string name);

        public signal void removeCategory(string name);

    }
}
