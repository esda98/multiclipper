/* StorageManager.vala
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
using Multiclipper;

namespace Multiclipper {
    public class StorageManager : Object {
        public static bool needPinStorage = false;
        public static bool needCategoryStorage = false;

        private static uint pinTimerId;
        private static uint categoryTimerId;

        static StorageManager? instance;

        StorageManager() {
            pinTimerId = GLib.Timeout.add_seconds(5, savePins);
            categoryTimerId = GLib.Timeout.add_seconds(5, saveCategories);
        }

        public static StorageManager getInstance() {
            if (instance == null) {
                instance = new StorageManager();
            }
            return instance;
        }

        private static bool savePins() {
            print("saving pins!\n");
            return true;
        }

        private static bool saveCategories() {
            print("saving categories!\n");
            return true;
        }

        public HashTable<string, ArrayList<Pin>> loadPins() {
            return new HashTable<string, ArrayList<Pin>>(str_hash, str_equal);
        }


    }
}
