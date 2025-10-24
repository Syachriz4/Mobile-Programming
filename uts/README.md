# RunHike Islami

Aplikasi mobile untuk melacak aktivitas lari dan pendakian dengan integrasi fitur islami.

## 📱 Deskripsi Aplikasi

RunHike Islami adalah aplikasi fitness tracking yang dirancang khusus untuk komunitas Muslim yang aktif. Aplikasi ini menggabungkan fitur pelacakan aktivitas outdoor (running & hiking) dengan fitur islami seperti pengingat waktu sholat dan konten dzikir.

## Fitur Utama:
- Dashboard - Overview aktivitas, weekly goal, recent activity list
- Running Mode - Real-time tracking lari dengan stats (distance, calories, speed)
- Hiking Mode - Real-time tracking pendakian dengan elevation tracking
- Islamic Features - Prayer reminders berbasis lokasi, dzikir content
- Profile - User profile, statistics, menu settings

## 📂 Struktur Project

```
lib/
├── main.dart             
├── models/
│   └── activity_model.dart    
├── pages/
│   ├── home_page.dart         
│   ├── running_page.dart     
│   ├── hiking_page.dart       
│   └── profile_page.dart     
└── widgets/
    └── activity_card.dart   

assets/
├── data/
│   └── activities.json       
└── images/
    └── avatar.png            
```

## 🎨 Design System

## Color Palette
- Primary Background: #0F0F1E (Dark Navy)
- Secondary Background: #1A1A2E (Dark Blue)
- Primary Accent: #6366F1 (Indigo)
- Secondary Accent: #8B5CF6 (Purple)
- Highlight: #FFA500 (Orange)
- Text Primary: #FFFFFF (White)
- Text Secondary: #A0A0A0 (Gray)

## Typography
- Heading: Segoe UI Bold (700-800 weight)
- Body: Segoe UI Regular (400 weight)
- Caption: Segoe UI Regular (400 weight), 10-12px
- Timer: Monospace font, 48px

## 📖 Halaman & Fungsi

## 1. HomePage (Dashboard)
- Menampilkan user greeting
- Weekly goal tracker dengan progress bar
- Recent activity list dari JSON
- Navigation ke halaman lain via BottomNavigationBar

Widgets: CustomScrollView, SliverList, FutureBuilder, ListView

## 2. RunningPage
- Map preview placeholder
- Stats grid (distance, calories, speed)
- Large timer display
- Pause/Resume button
- Prayer reminder box dengan location info

Widgets: GridView, FloatingActionButton, Container

## 3. HikingPage
- Map preview placeholder
- Stats grid (elevation focus)
- Large timer display
- Pause/Resume button
- Dzikir reminder box

Widgets: GridView, FloatingActionButton, Container

## 4. ProfilePage
- User profile header
- Statistics summary (km run, km hike, total calories)
- Menu items (Personal Parameters, Achievements, Islamic Content, Settings, Contact)

Widgets: CustomScrollView, SliverList, GridView

## Dummy Data (JSON)
Data disimpan dalam `assets/data/activities.json` dengan struktur:
- id: unique identifier
- type: 'running' atau 'hiking'
- distance: jarak dalam km
- duration: durasi dalam detik
- calories: kalori terbakar
- speed: kecepatan rata-rata
- date: tanggal aktivitas
- elevation: ketinggian (hanya untuk hiking)

## 👤 Author

**Bintang Syachriza Akbar**
- NIM: 230605110061
- Kelas: E
- Universitas Islam Negeri Maulana Malik Ibrahim Malang

