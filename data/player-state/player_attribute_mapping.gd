class_name PlayerAttributeMapping extends Resource

# each attribute has one mapping to each composed primitive
# weight determines the relative positive or negative weight
# of each primitive

## Composed primitive stat
@export var primitive : PlayerStatePrimitive
## Relative positive or negative influence on attribute
@export var weight : float
