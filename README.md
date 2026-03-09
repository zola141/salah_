# 🎲 Parchisi Multiplayer Game (LudoX)

A real-time multiplayer Ludo/Parchisi game built with Node.js, Socket.io, React, and MongoDB. Players can compete in 1v1 matches, track their statistics, earn achievements, and climb the leaderboard.

---

## 👥 Team Members & Roles

| Name | Role | Responsibilities |
|------|------|-----------------|
| **Anas** | Product Owner (PO) | Real-time chat system, WebSocket communication, online status, direct messaging, friends system |
| **Kamal** | Project Manager (PM) | Frontend framework, homepage design, room creation UI, user authentication flows |
| **Hamza** | Tech Lead | Analytics dashboard, data export/import, leaderboard system, database architecture |
| **Salah** | Developer | Backend framework, REST APIs, room management, authentication, socket handlers |
| **Soumya** | Developer | Game logic, bot AI, dice mechanics, pawn movement, game state management |

---

## 📋 Project Management Approach

### Organization Strategy
- **Agile methodology** with 2-week sprints
- **Modular architecture**: Each team member owns specific modules
- **Git workflow**: Feature branches → Pull Requests → Code review → Main branch
- **Daily standups**: Quick sync on progress and blockers
- **Task tracking**: Issues and milestones in GitHub Projects

### Communication
- **Slack**: Daily communication and quick questions
- **Zoom/Discord**: Weekly planning and code review sessions
- **Documentation**: Maintained in `/DOCS` folder (removed for production)

### Code Integration
- Backend routes organized by feature (`/src/routes/`)
- Frontend separated into modules (`kamal_part/`, `thegame/`, `hamza_part/`)
- Socket handlers centralized in `/src/socket/handlers.js`
- Shared models in `/src/models/`

---

## 🛠️ Technologies Used

### Backend
- **Node.js (v20)** - JavaScript runtime for server-side logic
  - *Justification*: Non-blocking I/O perfect for real-time applications
- **Express.js** - Web application framework
  - *Justification*: Lightweight, flexible routing, extensive middleware support
- **Socket.io** - Real-time bidirectional communication
  - *Justification*: WebSocket library with fallback mechanisms, room management, event broadcasting
- **MongoDB + Mongoose** - NoSQL database and ODM
  - *Justification*: Flexible schema for user data, match history, and game states. Easy JSON-like document storage

### Frontend
- **React + Vite** - UI library and build tool
  - *Justification*: Component-based architecture, fast development with HMM, optimized builds
- **TypeScript** - Type-safe JavaScript (Analytics dashboard)
  - *Justification*: Compile-time type checking, better IDE support, reduces runtime errors
- **Vanilla JavaScript** - Core game rendering
  - *Justification*: Direct DOM manipulation for better performance in game canvas

### Authentication & Storage
- **In-memory token store** - Session management
  - *Justification*: Fast access, suitable for development/demo purposes
- **Multer** - File upload handling (profile pictures)
  - *Justification*: Simple multipart/form-data handling for file uploads

### Build & Deployment
- **Make** - Build automation
  - *Justification*: Cross-platform build scripts, dependency management
- **NVM** - Node version management
  - *Justification*: Ensures consistent Node.js version across environments

---

## 🗄️ Database Schema

### User Model
```javascript
{
  email: String (unique, required),
  password: String (hashed, required),
  nickname: String (required),
  name: String,
  age: Number,
  gender: String,
  country: String,
  profileImageUrl: String,
  wins: Number (default: 0),
  losses: Number (default: 0),
  draws: Number (default: 0),
  matches: Number (default: 0),
  matchHistory: [
    {
      matchId: String,
      opponent: String,
      opponentNickname: String,
      result: String (win/loss/draw),
      duration: Number,
      scores: Object,
      date: Date
    }
  ],
  achievements: [
    {
      id: String,
      unlockedAt: Date
    }
  ],
  createdAt: Date,
  updatedAt: Date
}
```

### GameRoom Model
```javascript
{
  roomCode: String (unique, required),
  createdBy: String (email),
  maxPlayers: Number (default: 2),
  players: [
    {
      email: String,
      nickname: String,
      color: String,
      socketId: String
    }
  ],
  status: String (waiting/playing/finished),
  createdAt: Date
}
```

### ChatMessage Model
```javascript
{
  roomId: String (required),
  senderEmail: String (required),
  senderNickname: String,
  senderAvatar: String,
  content: String (required),
  createdAt: Date
}
```

### DirectMessage Model
```javascript
{
  from: String (email, required),
  to: String (email, required),
  content: String (required),
  read: Boolean (default: false),
  createdAt: Date
}
```

### Friendship Model
```javascript
{
  requesterEmail: String (required),
  receiverEmail: String (required),
  status: String (pending/accepted/rejected),
  createdAt: Date
}
```

---

## ✨ Features & Implementation

### Core Gameplay (Soumya)
- ✅ Parchisi/Ludo game logic with 4 pawns per player
- ✅ Dice rolling mechanics with bonus turns on 6
- ✅ Pawn movement with collision detection
- ✅ Safe zones and capture mechanics
- ✅ AI bot opponents with difficulty levels
- ✅ Turn-based gameplay with automatic turn switching
- ✅ Win condition detection
- ✅ Game state persistence and recovery

### Multiplayer System (Salah)
- ✅ Room creation and joining
- ✅ 1v1 matchmaking system
- ✅ WebSocket connection management
- ✅ Real-time game state synchronization
- ✅ Player disconnection handling with grace period
- ✅ Move validation and broadcasting
- ✅ Game result recording

### User Authentication (Kamal + Salah)
- ✅ User registration with email/password
- ✅ Login with session management
- ✅ Profile management (name, age, gender, country)
- ✅ Profile picture upload
- ✅ Password hashing for security

### Real-Time Chat (Anas)
- ✅ In-game chat during matches
- ✅ Chat history persistence
- ✅ Direct messaging between users
- ✅ Friends system (add, accept, list)
- ✅ Online/offline status indicators
- ✅ Typing indicators
- ✅ Message broadcasting to room members

### Statistics & Progression (Hamza + Salah)
- ✅ Win/loss/draw tracking
- ✅ Match history with opponents and dates
- ✅ ELO rating calculation
- ✅ Win rate percentage
- ✅ Achievement system (First Win, Second Win, Third Win)
- ✅ Statistics API endpoints

### Analytics Dashboard (Hamza)
- ✅ Leaderboard with top players
- ✅ Player ranking by ELO
- ✅ Data export functionality
- ✅ Player search and filtering
- ✅ Interactive charts and graphs

### Frontend Pages (Kamal)
- ✅ Homepage with game introduction
- ✅ Room selection interface
- ✅ Login/Register pages
- ✅ Profile management page
- ✅ Responsive design

### API Endpoints (Salah)
- ✅ `/api/auth/*` - Authentication routes
- ✅ `/api/users/*` - User management
- ✅ `/api/rooms/*` - Room creation and joining
- ✅ `/api/matches/*` - Match history
- ✅ `/api/progression/*` - Player statistics
- ✅ `/api/chat/*` - Chat and friends management
- ✅ `/api/analytics/*` - Analytics data
- ✅ `/api/achievements` - Achievement tracking

---

## 🎯 Chosen Modules & Points

### Major Modules (2 points each)

1. **Use backend framework and frontend framework** — **2 points**
2. **Web-based game (multiplayer)** — **2 points**
3. **Remote players** — **2 points**
4. **Implement real-time features** — **2 points**
5. **Allow users to interact with other users** — **2 points**
6. **Standard user management** — **2 points**
7. **Advanced analytics dashboard** — **2 points**
8. **Challenging AI / game logic** — **2 points**

### Minor Modules (1 point each)

1. **Data export and import** — **1 point**
2. **Online status / presence** — **1 point**

**Total Points: (8 × 2) + (2 × 1) = 18 points**

---

## 👤 Individual Contributions

### Anas (Product Owner)
- **Socket.io Communication**: Implemented real-time chat handlers
- **Chat System**: Message broadcasting, history persistence
- **Direct Messaging**: User-to-user private messaging
- **Friends System**: Friend requests, acceptance, listing
- **Online Status**: Real-time presence indicators
- **Documentation**: Chat integration guides
- **Lines of Code**: ~1,500 lines

### Kamal (Project Manager)
- **Homepage Design**: Landing page with game introduction
- **Room UI**: Room creation and joining interface
- **Authentication Pages**: Login, register, profile pages
- **Responsive Layout**: Mobile-friendly design
- **Navigation**: User flow and page routing
- **Project Planning**: Sprint organization, task assignment
- **Lines of Code**: ~2,000 lines

### Hamza (Tech Lead)
- **Analytics Dashboard**: Leaderboard and statistics visualization
- **Data Export**: CSV/JSON export functionality
- **Database Design**: Schema planning and optimization
- **TypeScript Integration**: Type-safe analytics frontend
- **Code Reviews**: Technical oversight and quality assurance
- **Architecture Decisions**: Technology stack choices
- **Lines of Code**: ~1,800 lines

### Salah (Developer)
- **Backend Framework**: Express server setup and configuration
- **REST API**: All backend routes and endpoints
- **Room Management**: Create, join, leave room logic
- **Socket Handlers**: Game state synchronization
- **Authentication**: User registration, login, token management
- **Database Models**: Mongoose schemas for all collections
- **Game Result Recording**: Win/loss tracking
- **Lines of Code**: ~3,500 lines

### Soumya (Developer)
- **Game Logic**: Complete Parchisi/Ludo rules implementation
- **Pawn Movement**: Position calculation, collision detection
- **Dice Mechanics**: Random rolling, bonus turns
- **AI Bots**: Intelligent opponent behavior
- **Game State**: State management and persistence
- **Win Conditions**: Game completion detection
- **Canvas Rendering**: Game board and piece visualization
- **Lines of Code**: ~4,000 lines

---

## 🚀 Installation & Setup

### Prerequisites
- Node.js v20 or higher
- MongoDB (local or MongoDB Atlas)

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd salah_
   ```

2. **Install dependencies**
   ```bash
   make install
   ```

3. **Configure MongoDB**
   - Update `src/config.js` with your MongoDB connection string

4. **Build the project**
   ```bash
   make build
   ```

5. **Start the server**
   ```bash
   make start
   ```

6. **Access the application**
   - Homepage: http://localhost:3000
   - Game: http://localhost:3000/game
   - Leaderboard: http://localhost:3000/leaderboard

---

## 📁 Project Structure

```
.
├── Makefile                 # Build automation
├── package.json             # Root dependencies
├── server.js                # Main Express server
├── src/
│   ├── config.js            # Configuration
│   ├── models/              # MongoDB schemas
│   ├── routes/              # REST API endpoints
│   ├── socket/              # Socket.io handlers
│   ├── middleware/          # Auth & CORS
│   └── utils/               # Helper functions
├── public/                  # Static HTML pages
│   ├── login.html
│   ├── register.html
│   ├── profile.html
│   └── stats.html
├── thegame/                 # Game frontend (Vite + React)
├── kamal_part/              # Homepage frontend
└── hamza_part/frontend/     # Analytics dashboard
```

---

## 🎮 How to Play

1. **Register/Login**: Create an account or log in
2. **Create/Join Room**: Enter a room code or create new room
3. **Wait for Opponent**: Room supports 2 players
4. **Roll Dice**: Click dice to roll (6 gives bonus turn)
5. **Move Pawns**: Click pawn to move by dice value
6. **Capture Opponents**: Land on opponent pawn to send it home
7. **Win**: Get all 4 pawns to the finish zone first

---

## 🏆 Achievements

- **🎉 First Win**: Win your first match
- **🔥 Second Win**: Win 2 matches
- **⭐ Third Win**: Win 3 matches

---

## 📊 API Documentation

### Authentication
- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - Login user

### Users
- `GET /api/users/me` - Get current user profile
- `PUT /api/users/me` - Update user profile
- `POST /api/users/upload` - Upload profile picture

### Rooms
- `POST /api/rooms/create` - Create game room
- `POST /api/rooms/join` - Join existing room
- `GET /api/rooms/:roomCode` - Get room details

### Matches
- `GET /api/matches/history` - Get match history

### Progression
- `GET /api/progression/progression` - Get player stats

### Chat
- `GET /api/chat/friends` - Get friends list
- `POST /api/chat/friends/request/:email` - Send friend request
- `POST /api/chat/friends/accept/:email` - Accept friend request
- `GET /api/chat/dm/:email` - Get direct messages

### Analytics
- `GET /api/analytics/leaderboard` - Get top players

---

## 🔧 Technologies Versions

- Node.js: 20.x
- Express: 4.18.x
- Socket.io: 4.6.x
- React: 18.2.x
- MongoDB: 6.x
- Mongoose: 8.x
- Vite: 5.x

---

## 📝 License

This project is developed as part of an academic assignment.

---

## 🙏 Acknowledgments

Special thanks to all team members for their dedication and collaboration in building this multiplayer game platform.

---

**Last Updated**: March 9, 2026
