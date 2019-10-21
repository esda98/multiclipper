/* HistoryManager.vala
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

namespace Multiclipper {
    public class HistoryManager : Object {
        static HistoryManager? instance;
        Clipboard defaultClip;
        ArrayList<HistoricClipboard> history = new ArrayList<HistoricClipboard>();


        HistoryManager() {
            defaultClip = Clipboard.get_default(Display.get_default());
            defaultClip.owner_change.connect(manageChange);
        }

        public static HistoryManager getInstance() {
            if (instance == null) {
                instance = new HistoryManager();
            }
            return instance;
        }

        private void manageChange(EventOwnerChange change) {
            stdout.printf("Reason: %s\n", change.reason.to_string());
            stdout.printf("Type: %s\n", change.type.to_string());
            stdout.printf("Selection: %s\n", change.selection.to_string());
            stdout.printf("something changed\n");
            if (change.reason == OwnerChange.NEW_OWNER) {
                stdout.printf("new owner\n");
                stdout.printf("atom: %s\n", change.selection.name());
                defaultClip.request_text(recieveText);
            }
        }

        private void recieveText(Clipboard clipboard, string? text) {
            stdout.printf("attemtping to handle text recieve\n");
            if (text == null) { return; }
            stdout.printf("recieved text: %s\n", text);
            string notNullText = ((string)text);
            removeHistoryItemIfPresent(notNullText);
            var newItem = new HistoricClipboard(notNullText);
            history.insert(0,newItem);
            stdout.printf("History Length: %d\n", history.size);
            newHistoryItem(newItem);
        }

        public void removeHistoryItemIfPresent(string text) {
            //see if this item is present already in this list, deleting it and adding the new one at the end of the list if it is the case
            for (int i = 0; i < history.size; i++) {
                if (history[i].textValue == text) {
                    history.remove_at(i);
                    removeHistoryItem(i);
                    break;
                }
            }
        }

        public signal void newHistoryItem(HistoricClipboard item);

        public signal void removeHistoryItem(int index);

    }
}
