### Filter Designing Digital
#### How to use

Define Variables
```
Classifcation = "Butterworth" or "Chebyshev"
Type = "Low" or "High" or "Band" or "Notch"
Amax = #
Amin = #
F = [Fpass, Fstop];
F = [Fpass1, Fpass2, Fpass3, Fpass4];
```
Then call either filter type.
```
filter = Digital(Classification, Type, Amax, Amin, F)
```
Diplay the coefficients with
```
filter.Display
```
