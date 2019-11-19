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
#### View Design Values
```
design
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
