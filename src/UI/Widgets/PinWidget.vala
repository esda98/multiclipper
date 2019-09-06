/* window.vala
 *
 * Copyright 2019 Erik
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
	[GtkTemplate (ui = "/com/sciocode/multiclipper/UI/Widgets/PinWidget.ui")]
	public class PinWidget : EventBox {
		[GtkChild]
		Label lblTitle;
		[GtkChild]
		Label lblText;

		public signal void copyText();

		public PinWidget (Pin pinToDisplay) {
            lblTitle.set_text(pinToDisplay.name);
            lblText.set_text(pinToDisplay.text);
            this.button_release_event.connect(pinClicked);
            this.copyText.connect(pinToDisplay.copyTextToClipboard);
		}

        private bool pinClicked(Widget click, EventButton event) {
            print ("The button was clicked with entry text: %s\n", lblText.get_text());
            copyText();
            return true;
        }
	}
}
