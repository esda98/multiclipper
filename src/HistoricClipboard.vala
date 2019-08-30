using Gtk;

namespace Multiclipper {
    public class HistoricClipboard : Object {
        public string textValue;

        public HistoricClipboard(string givenTextValue) {
            textValue = givenTextValue;
        }

        public Widget buildWidget() {
            var btnForHistory = new Button.with_label(textValue + " hi!");
            btnForHistory.clicked.connect(() => {stdout.printf("Clicked History of text value: %s\n", textValue);});
            return btnForHistory;
        }
    }
}
