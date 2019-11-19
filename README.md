## filterdesign
Personal Filter Design Git

### Filter Designing
#### How to use

Define Variables
```
Amax = #
Amin = #
w = [wp, ws];
w = [wp1, wp2, ws1 ws2];
type = "Low" or "High" or "Band" or "Notch"
```
Then call either filter type.
```
filter = Butterworth(Amax, Amin, w, type);
filter = Chebyshev(Amax, Amin, w, type);
```
You can see the corresponding values by typing:
```
filter.poles
filter.w0
filter.Q
```
Graph the Response with:
```
filter.Graph
```

