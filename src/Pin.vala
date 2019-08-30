using Gtk;

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
            var btnForPin = new Button.with_label(name);
		    btnForPin.clicked.connect(copyTextToClipboard);
		    return btnForPin;
        }
    }
}
