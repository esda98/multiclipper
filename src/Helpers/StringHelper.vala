/* StringHelper.vala
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

namespace Multiclipper {
    public class StringHelper {
        public static bool anyNullOrBlank(string[] inputs) {
            //check each input for a null or whitespace value, returning false when one exists that matches that
            foreach (var i in inputs) {
                print("checking: " + i + "\n");
                if (i == null || i.strip() == "") return true;
            }
            return false;
        }
    }
}
