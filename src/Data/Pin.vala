/* Pin.vala
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
using Multiclipper;

namespace Multiclipper {
    public class Pin : Object {
        public string name;
        public string text;
        public string category;

        public Pin(string givenName, string givenText, string givenCategory) {
            name = givenName;
            text = givenText;
            category = givenCategory;
        }

        public void copyTextToClipboard() {
            var defaultClip = Clipboard.get_default(Gdk.Display.get_default());
            defaultClip.set_text(text, text.length);
        }

        public Widget buildWidget() {
		    return new PinWidget(this);
        }
    }
}
