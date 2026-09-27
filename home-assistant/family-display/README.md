# Family display

Native Home Assistant dashboard definitions for a wall-mounted family calendar. No HACS component, custom card, integration, or backend is part of this MVP.

## Status

**v0.0.1 is deployed and validated in Home Assistant.** It is a native, YAML-mode family calendar dashboard; no HACS component, custom card, integration, or backend is in scope.

## First dashboard

`family-calendar.yaml` renders a live date/time header and the native calendar card in month view. The card itself offers native day and seven-day-list views and event details.

Initial calendar set:

| Calendar | Purpose |
| --- | --- |
| `calendar.family` | Shared household calendar; candidate destination for new events |
| `calendar.jackson` | Jackson's personal calendar |
| `calendar.kristin_work` | Kristin's work calendar |
| `calendar.anniversaries` | Anniversaries |
| `calendar.mealie_dinner` | Dinner plan |

`calendar.jackson_work` is deliberately excluded for now. Calendar/person colors are owned by the underlying calendar sources; keep shared events on `calendar.family` until a person/event model is needed.

## Deploy or update manually

The live Home Assistant configuration is not GitOps-managed. Apply dashboard changes manually, then keep this repository's YAML as the source of truth.

1. Copy `family-calendar.yaml` to `<HA config>/dashboards/family-calendar.yaml`.
2. Add this dashboard registration to `<HA config>/configuration.yaml` if it does not already exist (merge with an existing `lovelace:` section; do not duplicate it):

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

## v0.0.1 validation result

The native calendar card displays events and opens their details, but has no add/edit-event interface. `calendar.family` supports Home Assistant's `calendar.create_event` action; the card does not expose it. Direct event entry is deferred as a separate feature.

## Work queue

### Now — v0.0.2: tablet operation

Choose the actual display, mount, power, and browser/kiosk setup. Verify touch targets, wake behavior, and recovery after Home Assistant or tablet reboot. This is deployment work, not dashboard feature work.

### Later — one observed daily-workflow improvement

After a week of use, promote exactly one proven need: a today screen, chores, a shopping list, or a calendar-creation workaround. Keep it native unless that single need cannot be met natively.

## Tracking

Keep this README as the product source of truth. Use one GitHub issue per committed work item once GitHub CLI authentication is available; do not add a board, labels, or automation until issue volume makes the README insufficient.

## Deferred

Today screen, chores, lists beyond `todo.shopping_list`, event editing/recurrence, points, kiosk behavior, and any custom/HACS work wait until this native calendar view is used on the actual display.
