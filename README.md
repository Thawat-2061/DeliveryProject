# Delivery Mobile Application

## Overview

Delivery Mobile Application is a cross-platform mobile application designed to manage parcel delivery between senders and receivers through a rider. The application enables users to create delivery requests, track shipment progress, monitor rider locations in real time, and verify deliveries with photo confirmation.

The system consists of a Flutter mobile application connected to a Node.js RESTful API, providing an efficient and transparent delivery management process.

---

## Objectives

- Simplify parcel delivery management
- Enable real-time shipment tracking
- Improve communication between sender, rider, and receiver
- Record delivery evidence through photo verification
- Monitor rider location during transportation

---

## Features

### Authentication
- User Registration
- Login & Logout
- Profile Management

### Sender
- Create delivery requests
- Enter pickup and destination addresses
- View delivery history
- Track shipment status

### Rider
- View assigned deliveries
- Accept delivery requests
- Update delivery status
- Upload proof-of-delivery photos
- Share real-time GPS location

### Receiver
- View incoming deliveries
- Track shipment progress
- Confirm successful delivery

### Shipment Tracking
- Pending
- Accepted
- Picked Up
- In Transit
- Arrived at Destination
- Delivered
- Completed

### Photo Verification
- Capture pickup photos
- Capture delivery confirmation photos
- Store delivery evidence

### GPS Tracking
- Display rider's current location
- Track delivery route
- Estimate delivery progress

---

## Technology Stack

### Mobile
- Flutter (Dart)

### Backend
- Node.js
- Express.js

### Database
- MySQL
- Firebase

### Tools
- Git
- GitHub
- Postman
- Visual Studio Code

---

## System Workflow

```
Sender
   │
Create Delivery
   │
   ▼
Backend API
   │
Assign Rider
   │
   ▼
Rider
   │
Pickup Parcel
   │
Upload Pickup Photo
   │
Update Status
   │
Share GPS Location
   │
Deliver Parcel
   │
Upload Delivery Photo
   │
   ▼
Receiver
Confirm Delivery
```

---

## Delivery Status

- Pending
- Picked Up
- In Transit
- Delivered

---

## Screenshots


---

## My Responsibilities

- Developed the mobile application using Flutter
- Designed responsive user interfaces
- Integrated RESTful APIs with the backend
- Implemented authentication and user management
- Developed delivery request workflow
- Implemented shipment status tracking
- Integrated GPS location tracking
- Implemented photo upload for pickup and delivery confirmation
- Tested and debugged application features

---

## Installation

```bash

```

---

## Future Improvements

- Push Notifications
- QR Code Delivery Verification
- Electronic Signature Confirmation
- Route Optimization
- In-app Chat



---

## License

This project was developed for educational purposes.
