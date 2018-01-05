## Configuring the Pivot Table Widget

### Tags (What to group the data by)
 e.g driverId, supervisorId,deviceId


### Metric Names (What data columns you want in the report)
 e.g Engine Hours, Idling


### JSON (Allows you to override the table behaviour e.g specify how you want the grouping fields to be used)
 e.g as Report Filters or Rows 
```javascript
{
    "report": {
        "reportFilters": [
            {
                "caption": "Super Visor",
                "uniqueName": "supervisorId"
            }
        ],
        "rows": [
            {
                "caption": "Driver",
                "uniqueName": "driverId"
            },
            {
                "caption": "Vehicle",
                "uniqueName": "deviceId"
            }
        ]
    }
}
```
