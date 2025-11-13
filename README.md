# openelevation
api for open-elevation.com lookup site 
# Example
```nim
import asyncdispatch, openelevation, json, strutils
let data = waitFor get_elevation(10.0,10.0)
echo data
```

# Launch (your script)
```
nim c -d:ssl -r  your_app.nim
```
