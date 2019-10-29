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
using Multiclipper;

namespace Multiclipper {
    public class PinManager : Object {
        static PinManager? instance;
        Clipboard defaultClip;
        Mutex pinLock = Mutex();
        HashTable<string, ArrayList<Pin>> pinCategories = new HashTable<string, ArrayList<Pin>>(str_hash, str_equal);

        PinManager() {
            defaultClip = Clipboard.get_default(Display.get_default());
            loadCategories();
        }

        public static PinManager getInstance() {
            if (instance == null) {
                instance = new PinManager();
            }
            return instance;
        }

        public bool insertNewCategory(string name) {
            pinLock.lock();
            if (pinCategories.get(name) != null) {
                pinLock.unlock();
                return false;
            }
            pinCategories.insert(name, new ArrayList<Pin>());
            newCategory(new Category(name));
            pinLock.unlock();
            return true;
        }

        public async void loadCategories() {
            //later on read from file of saved categories and pins for those categories, just do a default for now
            print("inserting new category!\n");
            insertNewCategory("Default");
        }

        public ArrayList<string> getAllCategories() {
            pinLock.lock();
            //use a value type of array to keep it from changing. I don't think it will but I don't want that chance
            var keysArr = pinCategories.get_keys_as_array();
            pinLock.unlock();
            var keys = new ArrayList<string>();
            foreach (var k in keysArr) {
                keys.add(k);
            }
            return keys;
        }


        public bool insertNewPin(string categoryName, string pinName, string pinText) {
            //ensure the values entered are valid, likely checked already but let's be safe
            if (StringHelper.anyNullOrBlank({categoryName, pinName, pinText})) return false;
            var newPinObj = new Pin(pinName, pinText, categoryName);
            //make sure the category name we are looking for is present
            pinLock.lock();
            var categoryList = pinCategories.get(categoryName);
            if (categoryList == null) return false;
            //add new pin to the beginning of the list
            categoryList.insert(0, newPinObj);
            pinLock.unlock();
            newPin(newPinObj);
            return true;
        }

        public ArrayList<Pin> getPinsForCategory(string categoryName) {
            var categoryList = pinCategories.get(categoryName);
            if (categoryList == null) return new ArrayList<Pin>();
            return categoryList;
        }


        public signal void newCategory(Category newCategory);
        public signal void removeCategory(Category removedCategory);

        public signal void newPin(Pin newPin);

    }
}
