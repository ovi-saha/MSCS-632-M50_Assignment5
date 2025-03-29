#include <iostream>
#include <vector>
using namespace std;

// Base class Ride
class Ride {
protected:
    int rideID;
    string pickupLocation, dropoffLocation;
    double distance;
public:
    // Constructor to initialize ride details
    Ride(int id, string pickup, string dropoff, double dist)
        : rideID(id), pickupLocation(pickup), dropoffLocation(dropoff), distance(dist) {}

    virtual double calculateFare() = 0; // Pure virtual function making Ride an abstract class

    // Virtual function to display ride details
    virtual void rideDetails() {
        cout << "Ride ID: " << rideID << "\nPickup: " << pickupLocation 
             << "\nDropoff: " << dropoffLocation << "\nDistance: " << distance << " miles\n";
    }

    virtual ~Ride() {} // Virtual destructor to allow proper cleanup in derived classes
};

// Derived class StandardRide
class StandardRide : public Ride {
public:
    // Constructor for StandardRide
    StandardRide(int id, string pickup, string dropoff, double dist)
        : Ride(id, pickup, dropoff, dist) {}

    // Overriding calculateFare for StandardRide
    double calculateFare() override {
        return distance * 2.0; // Fare is $2 per mile
    }

    // Overriding rideDetails to include fare details
    void rideDetails() override {
        Ride::rideDetails();
        cout << "Ride Type: Standard\nFare: $" << calculateFare() << "\n";
    }
};

// Derived class PremiumRide
class PremiumRide : public Ride {
public:
    // Constructor for PremiumRide
    PremiumRide(int id, string pickup, string dropoff, double dist)
        : Ride(id, pickup, dropoff, dist) {}

    // Overriding calculateFare for PremiumRide
    double calculateFare() override {
        return distance * 3.5; // Fare is $3.5 per mile
    }

    // Overriding rideDetails to include fare details
    void rideDetails() override {
        Ride::rideDetails();
        cout << "Ride Type: Premium\nFare: $" << calculateFare() << "\n";
    }
};

// Driver class
class Driver {
private:
    vector<Ride*> assignedRides; // Stores assigned rides for the driver
public:
    int driverID;
    string name;
    double rating;

    // Constructor to initialize driver details
    Driver(int id, string dname, double drating) : driverID(id), name(dname), rating(drating) {}

    // Function to add a ride to the driver's assigned rides
    void addRide(Ride* ride) {
        assignedRides.push_back(ride);
    }

    // Function to display driver details and completed rides
    void getDriverInfo() {
        cout << "Driver ID: " << driverID << "\nName: " << name << "\nRating: " << rating << "\n";
        cout << "Completed Rides:\n";
        for (auto ride : assignedRides) {
            ride->rideDetails(); // Display details of each ride
        }
    }
};

// Rider class
class Rider {
private:
    vector<Ride*> requestedRides; // Stores requested rides by the rider
public:
    int riderID;
    string name;

    // Constructor to initialize rider details
    Rider(int id, string rname) : riderID(id), name(rname) {}

    // Function to request a ride
    void requestRide(Ride* ride) {
        requestedRides.push_back(ride);
    }

    // Function to view all requested rides
    void viewRides() {
        cout << "Rider ID: " << riderID << "\nName: " << name << "\nRequested Rides:\n";
        for (auto ride : requestedRides) {
            ride->rideDetails(); // Display details of each ride
        }
    }
};

// Main function
int main() {
    // Creating a Rider object
    Rider rider1(1, "Alice");

    // Creating a Driver object
    Driver driver1(101, "Bob", 4.8);

    // Creating ride objects (Standard and Premium)
    Ride* ride1 = new StandardRide(1, "Downtown", "Uptown", 5.0);
    Ride* ride2 = new PremiumRide(2, "Airport", "Hotel", 10.0);

    // Rider requests rides
    rider1.requestRide(ride1);
    rider1.requestRide(ride2);

    // Driver gets assigned rides
    driver1.addRide(ride1);
    driver1.addRide(ride2);

    // Display rider details
    cout << "\n--- Rider Details ---\n";
    rider1.viewRides();

    // Display driver details
    cout << "\n--- Driver Details ---\n";
    driver1.getDriverInfo();

    // Cleanup dynamically allocated memory
    delete ride1;
    delete ride2;

    return 0;
}
