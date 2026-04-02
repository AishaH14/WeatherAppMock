# 🌤 Weather App

A UIKit-based iOS weather application that mimics the design and behavior of the Apple Weather app.

---

## Features

* Current Weather Display
* Hourly Forecast
* 10-Day Forecast (Static as per requirement)
* Additional Weather Details (Sunrise, Humidity, Visibility, etc.)
* City Search & Selection
* Calendar-based Day Selection
* Dynamic Background (Day/Night)
* Header Scroll Animation
* Loading Indicator
* Error Handling

---

## Architecture

The project follows a clean and organized structure:

* **Network Layer**

  * `NetworkManager` handles API requests

* **Service Layer**

  * `WeatherService` manages API endpoints

* **ViewModel Layer**

  * `WeatherViewModel` handles business logic

* **UI Layer**

  * UIKit + XIB-based views

---

## API

* Uses **OpenWeather API (v2.5)**
* Fetches:

  * Current Weather
  * Forecast Data

> Note: 10-day forecast is implemented as static data based on project requirements.

---

## Requirements

* UIKit only
* No Storyboards
* XIB-based UI
* Clean project structure
* Proper handling of loading and error states

---

## UI Inspiration

The app design is inspired by the native **Apple Weather app**.

---

## How to Run

1. Clone the repository
2. Open the project in Xcode
3. Build & Run on simulator or device

---

## 🧑‍💻 Author

Developed by **Aisha Hudasi**
