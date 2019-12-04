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

You can now graph the filters total repsones with the following call:
```
filter.GraphResp
```

If given the coefficients you can store them in an 3D array, in the refrence of [numerator or denominator (1 or 2), the 3 coef, section number]. Example Below:

Numerator 1: [1,2,1]
Denominator 1: [1,-0.9827,0.66648]
Numerator 2: [1,1,0]
Denominator 2: [1, -0.59771,0]
```
Hzcoef(1,:,1) = [1,2,1];
Hzcoef(2,:,1) = [1,-0.9827,0.66648];
Hzcoef(1,:,2) = [1,1,0];
Hzcoef(2,:,2) = [1, -0.59771,0];

Digital.Graph(Hzcoef)
```
