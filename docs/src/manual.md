# Manual

## Obligatory Interfaces

Obligatory interfaces must be implemented by all subtypes. Let's define an interface for calculating fuel consumption for different flying vehicles.

```@example interfaces_interaction
using InterfaceFunctions
using Unitful
using Unitful: Length

# Define an abstract type
abstract type FlyingVehicle end

# Define an obligatory interface for fuel consumption per distance
@interface fuel_consumption(vehicle::FlyingVehicle)

# Define concrete subtypes
struct Airplane <: FlyingVehicle end
struct Helicopter <: FlyingVehicle end
struct UFO <: FlyingVehicle end

# Implement the interface for each type
fuel_consumption(::Airplane) = 0.1u"L/km"
fuel_consumption(::Helicopter) = 0.2u"L/km"
fuel_consumption(::UFO) = 0.0u"L/km" # They have advanced technology! 👾

```

## Optional Interfaces

Optional interfaces have a default implementation that can be overridden. Let's add an interface for travel time, with a default implementation that assumes a constant speed.

```@example interfaces_interaction

# Define an optional interface for travel time
@interface fuel_consumed(vehicle::FlyingVehicle, distance::Length) = fuel_consumption(vehicle) * distance

# Now we can calculate fuel consumed for any flying vehicle
println("Airplane fuel for 1000km: ", fuel_consumed(Airplane(), 1000u"km"))
println("Helicopter fuel for 1000km: ", fuel_consumed(Helicopter(), 1000u"km"))

# Their physics just work differently I guess... 🚀
fuel_consumed(::UFO, ::Length) = 5u"L"

println("UFO fuel for 1000km: ", fuel_consumed(UFO(), 1000u"km"))
```

## Debug Logging

InterfaceFunctions.jl uses Julia's logging system to provide debug information.

### Enabling Logging

```@example interfaces_interaction; continued = true
using Logging

# Enable debug logging for interfaces
ENV["JULIA_DEBUG"] = "interfaces"
global_logger(ConsoleLogger(stderr, Logging.Debug))
```

Now we can examine the default interface calls in our code.
```@repl interfaces_interaction
ENV["JULIA_DEBUG"] = "interfaces" # hide
global_logger(ConsoleLogger(stderr, Logging.Debug)) # hide
fuel_consumed(Airplane(), 1000u"km") # Using the default implementation
```
