.. _admin_win_services:


Windows Services
````````````````

You only need to start "peek-logic-service" and "peek-restarter".

If you want to restart peek, just restart "peek-logic-service",
the worker, agent, field, and office services will shutdown and be restarted.

The **peek-restarter** service automatically restarts the **worker**, **field**, **office**, and
**agent** services. On windows, these services will stop when the **peek-logic-service** stops.

