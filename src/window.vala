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
using Gee;
using Multiclipper;

namespace Multiclipper {
	[GtkTemplate (ui = "/com/sciocode/multiclipper/window.ui")]
	public class Window : ApplicationWindow {
		[GtkChild]
		Button btnAddPin;
		[GtkChild]
		FlowBox boxPins;
		[GtkChild]
		ListBox boxHistory;

		Mutex historyLock = Mutex();
		Mutex pinLock = Mutex();

		//ArrayList<Pin> pins = new ArrayList<Pin>();
		GLib.ListStore history = new GLib.ListStore(typeof(HistoricClipboard));
		GLib.ListStore pins = new GLib.ListStore(typeof(Pin));

		public Window (Gtk.Application app) {
		    Gtk.Settings.get_default ().gtk_application_prefer_dark_theme = true;
			Object (application: app);
			btnAddPin.clicked.connect(newPinClicked);
            boxPins.bind_model(pins, createPinWidget);


			//setup binding of history
			boxHistory.bind_model(history, createHistoryWidget);

			var histManager = HistoryManager.getInstance();
			histManager.newHistoryItem.connect(newHistoryItem);
			histManager.removeHistoryItem.connect(removeHistoryItem);
		}

		void newPinClicked() {
		    pinLock.lock();
		    var newPin = new Pin("A Name " + pins.get_n_items().to_string(), "A Text Value " + pins.get_n_items().to_string(), "A Category");
		    pins.append(newPin);
		    pinLock.unlock();
		}

		 void newHistoryItem(HistoricClipboard item) {
		    historyLock.lock();
		    stdout.printf("new history item: %s\n", item.textValue);
		    history.insert(0, item);
		    historyLock.unlock();
		}

		public void removeHistoryItem(int index) {
		    historyLock.lock();
            history.remove(index);
            historyLock.unlock();
		}

		private Widget createHistoryWidget(Object item) {
            return ((HistoricClipboard)item).buildWidget();
		}

		private Widget createPinWidget(Object item) {
            return ((Pin)item).buildWidget();
		}

	}
}
