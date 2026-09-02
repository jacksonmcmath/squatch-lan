# Family display

Native Home Assistant dashboard definitions for a wall-mounted family calendar. No HACS component, custom card, integration, or backend is part of this MVP.

## First dashboard

`family-calendar.yaml` is a YAML-mode dashboard. It renders a live date/time header and the native calendar card in month view. The card itself offers native day and seven-day-list views and event details.

Initial calendar set:

| Calendar | Purpose |
| --- | --- |
| `calendar.family` | Shared household calendar; candidate destination for new events |
| `calendar.jackson` | Jackson's personal calendar |
| `calendar.kristin_work` | Kristin's work calendar |
| `calendar.anniversaries` | Anniversaries |
| `calendar.mealie_dinner` | Dinner plan |

`calendar.jackson_work` is deliberately excluded for now. Calendar/person colors are owned by the underlying calendar sources; keep shared events on `calendar.family` until a person/event model is needed.

## Deploy manually

This repository does not yet manage the live Home Assistant configuration, so this change is intentionally **not deployed**.

1. Copy `family-calendar.yaml` to `<HA config>/dashboards/family-calendar.yaml`.
2. Add this dashboard registration to `<HA config>/configuration.yaml` (merge with an existing `lovelace:` section; do not duplicate it):

   ```yaml
   lovelace:
     dashboards:
       family-calendar:
         mode: yaml
         title: Family Calendar
         icon: mdi:calendar-month
         show_in_sidebar: true
         filename: dashboards/family-calendar.yaml
   ```

3. Run Home Assistant's configuration check, then restart Home Assistant only after it passes.
4. Open **Family Calendar** and verify event detail, day/list switching, and whether `calendar.family` offers the desired touchscreen event-creation flow.

## Acceptance check

- The month view shows all five sources above.
- The header updates each minute without a browser refresh.
- An event opens to its native detail view.
- The day and list controls work at the intended tablet resolution.
- Creating a test event in `calendar.family` works from the display, or the gap is recorded before adding any workaround.

## Deferred

Today screen, chores, lists beyond `todo.shopping_list`, event editing/recurrence, points, kiosk behavior, and any custom/HACS work wait until this native calendar view is used on the actual display.
