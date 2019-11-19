multiclipper_sources = [
  'main.vala',
  'UI/Windows/MainWindow.vala',
  'UI/Widgets/PinWidget.vala',
  'UI/Widgets/HistoryWidget.vala',
  'UI/Widgets/CategoryWidget.vala',
  'Classes/HistoryManager.vala',
  'Classes/PinManager.vala',
  'Classes/StorageManager.vala',
  'Data/HistoricClipboard.vala',
  'Data/Pin.vala',
  'Data/Category.vala',
  'Helpers/StringHelper.vala'
]

multiclipper_deps = [
  dependency('gio-2.0', version: '>= 2.50'),
  dependency('gtk+-3.0', version: '>= 3.22'),
  dependency('gee-0.8', version: '>= 0.8'),
]

gnome = import('gnome')

multiclipper_sources += gnome.compile_resources('multiclipper-resources',
  'multiclipper.gresource.xml',
  c_name: 'multiclipper'
)

executable('multiclipper', multiclipper_sources,
  vala_args: '--target-glib=2.50',  dependencies: multiclipper_deps,
  install: true,
)
