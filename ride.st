"Base Ride Class"
Object subclass: Ride [
    | rideID pickupLocation dropoffLocation distance |

    "Class method to create a new Ride instance with details"
    Ride class >> newWithID: id pickup: pickup dropoff: dropoff distance: dist [
        ^ self new initializeWithID: id pickup: pickup dropoff: dropoff distance: dist.
    ]

    "Instance method to initialize a Ride object"
    Ride >> initializeWithID: id pickup: pickup dropoff: dropoff distance: dist [
        rideID := id.
        pickupLocation := pickup.
        dropoffLocation := dropoff.
        distance := dist.
    ]

    "Method to display ride details"
    Ride >> rideDetails [
        Transcript show: 'Ride ID: ', rideID asString, ' Pickup: ', pickupLocation, 
                        ' Dropoff: ', dropoffLocation, ' Distance: ', distance asString, ' miles'; cr.
    ]

    "Method to calculate fare, to be overridden in subclasses"
    Ride >> calculateFare [
        ^ 0. "Base class does not define fare, subclasses must override"
    ]
]

"Standard Ride Subclass"
Ride subclass: StandardRide [
    "Method to calculate fare for StandardRide"
    StandardRide >> calculateFare [
        ^ distance * 2.0. "Standard ride: $2 per mile"
    ]

    "Override rideDetails to include ride type and fare"
    StandardRide >> rideDetails [
        super rideDetails.
        Transcript show: 'Ride Type: Standard Fare: $', self calculateFare asString; cr.
    ]
]

"Premium Ride Subclass"
Ride subclass: PremiumRide [
    "Method to calculate fare for PremiumRide"
    PremiumRide >> calculateFare [
        ^ distance * 3.5. "Premium ride: $3.5 per mile"
    ]

    "Override rideDetails to include ride type and fare"
    PremiumRide >> rideDetails [
        super rideDetails.
        Transcript show: 'Ride Type: Premium Fare: $', self calculateFare asString; cr.
    ]
]

"Driver Class"
Object subclass: Driver [
    | driverID name rating assignedRides |

    "Class method to create a new Driver instance"
    Driver class >> newWithID: id name: dname rating: drating [
        ^ self new initializeWithID: id name: dname rating: drating.
    ]

    "Instance method to initialize a Driver object"
    Driver >> initializeWithID: id name: dname rating: drating [
        driverID := id.
        name := dname.
        rating := drating.
        assignedRides := OrderedCollection new. "Initialize an empty collection for rides"
    ]

    "Method to add a ride to the driver’s assigned rides"
    Driver >> addRide: ride [
        assignedRides add: ride.
    ]

    "Method to display driver details and completed rides"
    Driver >> getDriverInfo [
        | totalFare totalRides averageFare |

        Transcript show: 'Driver ID: ', driverID asString, ' Name: ', name, ' Rating: ', rating asString; cr.

        totalFare := 0.
        totalRides := assignedRides size.

        "Iterate over assigned rides to display details and compute total fare"
        assignedRides do: [:ride |
            ride rideDetails.
            totalFare := totalFare + ride calculateFare.
        ].

        "Avoid division by zero when computing the average fare"
        averageFare := (totalRides > 0) ifTrue: [ totalFare / totalRides ] ifFalse: [ 0 ].

        Transcript show: 'Total Rides: ', totalRides asString, ' Average Fare: $', averageFare asString; cr.
    ]
]

"Rider Class"
Object subclass: Rider [
    | riderID name requestedRides |

    "Class method to create a new Rider instance"
    Rider class >> newWithID: id name: rname [
        ^ self new initializeWithID: id name: rname.
    ]

    "Instance method to initialize a Rider object"
    Rider >> initializeWithID: id name: rname [
        riderID := id.
        name := rname.
        requestedRides := OrderedCollection new. "Initialize an empty collection for requested rides"
    ]

    "Method for the rider to request a ride"
    Rider >> requestRide: ride [
        requestedRides add: ride.
    ]

    "Method to display all requested rides"
    Rider >> viewRides [
        Transcript show: 'Rider ID: ', riderID asString, ' Name: ', name; cr.
        requestedRides do: [:ride | ride rideDetails].
    ]
]

"=== Test System ==="
| rider1 driver1 ride1 ride2 |

Transcript show: '--- Ride Sharing System ---'; cr.

"Create a rider and driver"
rider1 := Rider newWithID: 1 name: 'Alice'.
driver1 := Driver newWithID: 101 name: 'Bob' rating: 4.8.

"Create rides"
ride1 := StandardRide newWithID: 1 pickup: 'Downtown' dropoff: 'Uptown' distance: 5.0.
ride2 := PremiumRide newWithID: 2 pickup: 'Airport' dropoff: 'Hotel' distance: 10.0.

"Rider requests rides"
rider1 requestRide: ride1.
rider1 requestRide: ride2.

"Driver completes rides"
driver1 addRide: ride1.
driver1 addRide: ride2.

"Display rider details"
Transcript show: '--- Rider Details ---'; cr.
rider1 viewRides.

"Display driver details"
Transcript show: '--- Driver Details ---'; cr.
driver1 getDriverInfo.
