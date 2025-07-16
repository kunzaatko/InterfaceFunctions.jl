# Quick Start

## Defining Interfaces

```julia
using InterfaceFunctions
using Unitful

# Define an abstract type
abstract type FlyingVehicle end

# Define an obligatory interface
@interface fuel_consumption(vehicle::FlyingVehicle, distance::Unitful.Length)

# Define an optional interface with a default implementation
@interface function travel_time(vehicle::FlyingVehicle, distance::Unitful.Length)
    # Default implementation assumes a speed of 500 km/h
    return distance / (500u"km/h")
end
```

## Debug Logging

Enable logging for interface usage:

```julia
using Logging

# Enable debug logging for interfaces
ENV["JULIA_DEBUG"] = "interfaces"

# Create debug logger
global_logger(ConsoleLogger(stderr, Logging.Debug))
```