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
#### Desing Sallen-Key
```
design  = FilterType(poles,type,C,Ra);
```
#### View Design Values
```
design.DisplaySpec
```
