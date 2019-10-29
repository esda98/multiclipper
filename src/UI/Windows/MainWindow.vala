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
		//Display boxes
		[GtkChild]
		FlowBox boxPins;
		[GtkChild]
		ListBox boxHistory;
		[GtkChild]
		ListBox boxCategories;

		//New Category Elements
		[GtkChild]
		PopoverMenu flyNewCategory;
		[GtkChild]
		Entry txtNewCategoryName;

		//New Pin Elements
		[GtkChild]
		PopoverMenu flyNewPin;
		[GtkChild]
		Entry txtName;
		[GtkChild]
		TextView txtText;
		[GtkChild]
		ComboBoxText cboCategory;


		Mutex historyLock = Mutex();
		Mutex pinLock = Mutex();
		Mutex categoryLock = Mutex();

		//ArrayList<Pin> pins = new ArrayList<Pin>();
		GLib.ListStore history = new GLib.ListStore(typeof(HistoricClipboard));
		GLib.ListStore pins = new GLib.ListStore(typeof(Pin));
		GLib.ListStore categories = new GLib.ListStore(typeof(Category));

		public MainWindow (Gtk.Application app) {
		    Gtk.Settings.get_default ().gtk_application_prefer_dark_theme = true;
			Object (application: app);

            //setup model bindings for display boxes
            boxPins.bind_model(pins, createPinWidget);
			boxHistory.bind_model(history, createHistoryWidget);
			boxCategories.bind_model(categories, createCategoryWidget);
			boxCategories.row_selected.connect(newCategorySelected);

			var histManager = HistoryManager.getInstance();
			histManager.newHistoryItem.connect(newHistoryItem);
			histManager.removeHistoryItem.connect(removeHistoryItem);

			var pinManager = PinManager.getInstance();
			pinManager.newCategory.connect(newCategory);
			//get all current categories to pass through to build when these have been created before the pin manager is connected
			var currentCategories = pinManager.getAllCategories();
			print("got some categories\n");
			foreach (var cat in currentCategories) {
			    newCategory(new Category(cat));
			    print("cat: " + cat + "\n");
			}
		}

		//*** Start Callbacks
        //Pin Callbacks
		[GtkCallback]
		void btnNewPinClicked() {
		    print("new pin clicked!!\n");
		    //set active will not do anything if the index is out of bounds, no error, I can live with that
		    cboCategory.set_active(0);
		    flyNewPin.popup();
		}

        [GtkCallback]
		void btnCloseNewPinClicked() {
		    print("close new pin clicked!!\n");
		    //clear entered information if close is clicked, info will persist if you just click away
		    txtName.text = "";
		    txtText.buffer.text = "";
		    flyNewPin.popdown();
		}

        [GtkCallback]
		void btnSaveNewPinClicked() {
		    //ensure some values were entered
		    var name = txtName.text;
		    var text = txtText.buffer.text;
		    var category = cboCategory.get_active_text();
		    //put all three text values in an array for bulk checking of all of them
            if (StringHelper.anyNullOrBlank({name, text, category})) return;
		    print("save new pin clicked!!\n");
		    flyNewPin.popdown();
		}

		//Category Callbacks
		[GtkCallback]
		void btnNewCategoryClicked() {
		    print("new category clicked!!\n");
		    flyNewCategory.popup();
		}

        [GtkCallback]
		void btnCloseNewCategoryClicked() {
		    print("close new category clicked!!\n");
		    txtNewCategoryName.text = "";
		    flyNewCategory.popdown();
		}

        [GtkCallback]
		void btnSaveNewCategoryClicked() {
		    print("save new category clicked!!\n");
		    var newCatName = txtNewCategoryName.text;
		    if (newCatName == null || newCatName.strip() == "") return;
            print("category name: " + newCatName + "\n");
            PinManager.getInstance().insertNewCategory(newCatName);
            flyNewCategory.popdown();
		}
		//*** End Callbacks

		
		//*** Start Signal Handlers
		//History Handlers
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

		//Category Handlers
		void newCategorySelected(ListBox box, ListBoxRow? row) {
            if (row == null) return;
            print("new category selected!\n");
            var rowIndex = row.get_index();
            var matchingCategory = (Category)categories.get_item(rowIndex);
            print("matching category: " + matchingCategory.categoryName + "\n");
        }

		void newCategory(Category newCategory) {
		    categoryLock.lock();
		    stdout.printf("new category item: %s\n", newCategory.categoryName);
		    categories.append(newCategory);
		    cboCategory.append_text(newCategory.categoryName);
		    categoryLock.unlock();
		}

		void removeCategory(Category removedCategory) {
		    categoryLock.lock();

		    bool found = false;
		    uint i = 0;
		    var itemCount = categories.get_n_items();
		    //i will be the index of the matching category as long as found is true
		    //if found is not true, the category is not present and just ignore this call (should not happen but just in case)
		    for (; i < itemCount; i++) {
		        var item = (Category)categories.get_item(i);
		        if (item == null || item.categoryName != removedCategory.categoryName) continue;
		        found = true;
		        break;
		    }
		    if (found) { categories.remove(i); }
		    categoryLock.unlock();
		}

		//Pin Handlers
		///*** End Signal Handlers


        //*** Start Widget Creation
		private Widget createHistoryWidget(Object item) {
            return ((HistoricClipboard)item).buildWidget();
		}

		private Widget createPinWidget(Object item) {
            return ((Pin)item).buildWidget();
		}

		private Widget createCategoryWidget(Object item) {
            return new CategoryWidget((Category)item);
		}
		//*** End Widget Creation

	}
}
