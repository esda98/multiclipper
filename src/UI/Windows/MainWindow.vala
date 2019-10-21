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
	[GtkTemplate (ui = "/com/sciocode/multiclipper/UI/Windows/MainWindow.ui")]
	public class MainWindow : ApplicationWindow {
		[GtkChild]
		FlowBox boxPins;
		[GtkChild]
		ListBox boxHistory;
		[GtkChild]
		ListBox boxCategories;
		[GtkChild]
		PopoverMenu flyNewPin;

		Mutex historyLock = Mutex();
		Mutex pinLock = Mutex();
		Mutex categoryLock = Mutex();

		//ArrayList<Pin> pins = new ArrayList<Pin>();
		GLib.ListStore history = new GLib.ListStore(typeof(HistoricClipboard));
		GLib.ListStore pins = new GLib.ListStore(typeof(Pin));
		GLib.ListStore categories = new GLib.ListStore(typeof(string));

		public MainWindow (Gtk.Application app) {
		    Gtk.Settings.get_default ().gtk_application_prefer_dark_theme = true;
			Object (application: app);

            //setup model bindings for display boxes
            boxPins.bind_model(pins, createPinWidget);
			boxHistory.bind_model(history, createHistoryWidget);
			boxCategories.bind_model(categories, createCategoriesWidget);

			var histManager = HistoryManager.getInstance();
			histManager.newHistoryItem.connect(newHistoryItem);
			histManager.removeHistoryItem.connect(removeHistoryItem);

			var pinManager = PinManager.getInstance();
			pinManager.newCategory = newCategory;

		}


		[GtkCallback]
		void btnNewPinClicked() {
		    print("new pin clicked!!\n");
		    flyNewPin.popup();
		}

        [GtkCallback]
		void btnCloseNewPinClicked() {
		    print("close new pin clicked!!\n");
		    flyNewPin.popdown();
		}

        [GtkCallback]
		void btnSaveNewPinClicked() {
		    print("save new pin clicked!!\n");
		}

		void newPinClicked() {
		    pinLock.lock();
		    var newPin = new Pin("A Name " + pins.get_n_items().to_string(), "A Text Value " + pins.get_n_items().to_string(), "A Category");
		    pins.append(newPin);
		    pinLock.unlock();
		}

        //*** Signal Handlers
		void newHistoryItem(HistoricClipboard item) {
		    historyLock.lock();
		    stdout.printf("new history item: %s\n", item.textValue);
		    history.insert(0, item);
		    historyLock.unlock();
		}

		void removeHistoryItem(int index) {
		    historyLock.lock();
            history.remove(index);
            historyLock.unlock();
		}

		void newCategory(string categoryName) {
		    categoryLock.lock();
		    categories.append(categoryName);
		    categoryLock.unlock();
		}

		void removeCategory(string categoryName) {
		    categoryLock.lock();

		    bool found = false;
		    int i = 0;
		    //i will be the index of the matching category as long as found is true
		    //if found is not true, the category is not present and just ignore this call (should not happen but just in case)
		    foreach (string c in categories) {
		        if (c == categoryName) {
		            found = true;
		            break;
		        }
		        i++;
		    }
		    if (found) { categories.remove(i); }
		    categoryLock.unlock();
		}

		///*** End Signal Handlers


        //*** Widget Creation
		private Widget createHistoryWidget(Object item) {
            return ((HistoricClipboard)item).buildWidget();
		}

		private Widget createPinWidget(Object item) {
            return ((Pin)item).buildWidget();
		}

		private Widget createCategoryWidget(Object item) {
            return new CategoryWidget((string)item);
		}
		//*** End Widget Creation

	}
}
