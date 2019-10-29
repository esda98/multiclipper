/* Category.vala
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
    public class Category : Object {
        public string categoryName;

        public Category(string givenCategoryName) {
            categoryName = givenCategoryName;
        }

        public Widget buildWidget() {
            return new CategoryWidget(this);
        }
    }
}
