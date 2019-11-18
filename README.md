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

### Sallen-Key Design
Generate Poles using above designer
Then proceed to call the correct class for designing.

#### Define Variables
```
poles = filter.poles
type = "Case 1" or "Case 2"
C = # (Capcitor Value)
Ra = # (Resistor Value [If need for Case 1's])
```

#### Case 1 Low-Pass (Q-Based Gain)

Build Design
```
design = LowPass(poles,type,C,Ra);
```
#### Case 2 Low-Pass (0 dB Gain)
Build Design
```
design = LowPass(poles,type,C);
```

#### Case 1 High-Pass (Q-Based Gain)
Build Design
```
design = HighPass(poles,type,C,Ra);
```
#### Case 2 High-Pass (0 dB Gain)
Build Design
```
design = HighPass(poles,type,C);
```

#### Case 1 band-Pass (Type 1 Q-Based Gain)
Build Design
```
design = BandPass(poles,type,C,Ra);
```
#### Case 2 Band-Pass (Type 2 Q-Based Gain)
Build Design
```
design = BandPass(poles,type,C);
```
