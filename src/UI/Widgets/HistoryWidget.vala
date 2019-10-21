/* HistoryWidget.vala
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
	[GtkTemplate (ui = "/com/sciocode/multiclipper/UI/Widgets/HistoryWidget.ui")]
	public class HistoryWidget : EventBox {
		[GtkChild]
		Label lblText;

		public signal void copyText();

		public HistoryWidget (HistoricClipboard historyToDisplay) {
		    lblText.set_text(historyToDisplay.textValue);
		}

        [GtkCallback]
        public void btnDeleteClicked() {
            HistoryManager.getInstance().removeHistoryItemIfPresent(lblText.get_text());
        }

        [GtkCallback]
        public void btnCopyClicked() {
            var labelText = lblText.get_text();
            var defaultClip = Clipboard.get_default(Gdk.Display.get_default());
            defaultClip.set_text(labelText, labelText.length);
        }

	}
}
