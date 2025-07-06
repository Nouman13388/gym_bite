# gym_bite

GymBite is a fitness management platform that helps clients and trainers manage meal plans, workouts, consultations, progress tracking, and real-time communication using a hybrid backend with Firebase and Node.js.

## Overview:
GymBite is a mobile-first fitness management application designed to bridge the gap between users and personalized health solutions. The system leverages artificial intelligence to offer customized meal plans, workout routines, progress tracking, and real-time trainer-client interactions, all within a unified, user-friendly platform.

## Motivation & Problem Statement:
Traditional fitness apps often lack AI-driven personalization, integration between nutrition and workouts, or effective client-trainer communication. GymBite addresses these limitations by combining modern AI tools with real-time engagement features to deliver a holistic wellness experience.

## Key Features:

- Role-based access for clients, trainers, nutritionists, and admins
- AI-generated meal and workout plans tailored to individual goals
- Real-time chat and video consultation capabilities
- Fitness progress tracking and data visualization
- Admin control for trainer approval, reports, and analytics
- Integration with Firebase, MySQL, and external APIs

## Technical Implementation:
GymBite is developed using Flutter for the frontend and a Node.js + Firebase-powered backend with SQL for data management. The system follows Agile methodology with modular design and adheres to best practices for scalability, security, and performance.

## Setup Instructions

### Environment Configuration

1. Clone the repository
2. Copy the `.env.example` file to a new file named `.env`:
   ```bash
   cp .env.example .env
   ```
3. Fill in your Firebase configuration values in the `.env` file
4. Install dependencies:
   ```bash
   flutter pub get
   ```
5. Run the app:
   ```bash
   flutter run
   ```

### Environment Switching

The app supports different environments (development, staging, production):

1. Development: Uses localhost API (default)
   ```bash
   cp .env.development .env
   ```

2. Production: Uses the production API
   ```bash
   cp .env.production .env
   ```

3. Alternatively, you can just change the `ENVIRONMENT` variable in the `.env` file:
   ```
   ENVIRONMENT=production  # or development
   ```

Note: The `.env` file contains sensitive information and is not committed to version control.

## Outcome:
The project aims to deliver a scalable and intelligent health platform that benefits users with personalized guidance, seamless tracking, and expert consultation — all integrated into one comprehensive application.
