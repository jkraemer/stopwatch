# Stopwatch Plugin for Redmine

Minimal plugin that aims to make tracking your time with Redmine much easier.

## Features

- Adds a **Log time** menu item to the account menu (top right)
- That link leads to an overlay listing today's time entries, with a form that
  allows editing existing or creating a new entry.
- Time entries can be started / stopped from the overlay as well as via their
  context menu. There can only be one currently running entry, which will be
  periodically updated with the time lapsed since it was started. Previously
  running entry is stopped automatically when another is started.
- The hours:minutes of the currently *running* entry is highlighted in time
  entry listings as well as shown next to the **Log time** menu item as well as
  in the window title.
- Creating an entry with 0 minutes saves it in *running* state.

![Screenshow](https://github.com/jkraemer/stopwatch/raw/screenshots/img/screenshot.png)

## Installation

Add the plugin to your Redmine installation's `plugins` folder, restart
Redmine. No database migrations necessary.


## License

Copyright (C) 2020 [Jens Krämer](https://jkraemer.net)

The Stopwatch plugin for Redmine is free software: you can redistribute
it and/or modify it under the terms of the GNU General Public License as
published by the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

The Stopwatch plugin for Redmine is distributed in the hope that it
will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General
Public License for more details.

You should have received a copy of the GNU General Public License along with
the plugin. If not, see [www.gnu.org/licenses](https://www.gnu.org/licenses/).

