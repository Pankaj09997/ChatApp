# Chat Application

This is a **Chat Application** built using **Flutter** for the frontend and **Django Rest Framework (DRF)** for the backend. The application includes features like sending friend requests and messaging, but users can only send messages once the friend request is accepted.

---

## Features

- **User Authentication**: Secure login and registration using JWT authentication.
- **Friend Requests**: 
  - Send friend requests to other users.
  - Accept or decline friend requests.
  - Messaging is only allowed once a friend request is accepted.
- **Real-time Messaging**: Communicate in real time using WebSockets.
- **Chat History**: Retrieve past messages in a conversation.
- **Responsive UI**: Built with Flutter for a seamless experience across devices.

---

## Tech Stack

### Frontend
- **Flutter**: Cross-platform mobile application development.

### Backend
- **Django Rest Framework (DRF)**: Backend API development.
- **Django Channels**: WebSocket integration for real-time messaging.
- **PostgreSQL**: Database to store user and chat data.

---

## Setup Instructions

### Prerequisites
- Flutter SDK installed.
- Python 3.10+ installed.
- PostgreSQL installed and configured.
