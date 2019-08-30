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
            //see if this item is present already in this list, deleting it and adding the new one at the end of the list if it is the case
            for (int i = 0; i < history.size; i++) {
                if (history[i].textValue == notNullText) {
                    history.remove_at(i);
                    removeHistoryItem(i);
                    break;
                }
            }

            var newItem = new HistoricClipboard(notNullText);
            history.add(newItem);
            stdout.printf("History Length: %d\n", history.size);
            newHistoryItem(newItem);
        }

        public signal void newHistoryItem(HistoricClipboard item);

        public signal void removeHistoryItem(int index);

    }
}
