# Quick Start Guide - RunHike Islami UAS

## 🚀 Getting Started in 5 Minutes

### Prerequisites
- Flutter SDK 3.9.0+
- Dart 3.0+
- Git
- Android Studio / Xcode (for emulator)

### 1. Clone Repository
```bash
git clone https://github.com/BintangS4/Mobile-Programming.git
cd Mobile-Programming/uas
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Run Application
```bash
flutter run
```

---

## 📱 Quick Feature Test Checklist

### Test 1: Home Page (2 min)
- [ ] App launches successfully
- [ ] See "Welcome, Andrew Sinclair" greeting
- [ ] See weekly goal (default 50 km)
- [ ] Tap settings icon → dialog appears
- [ ] Edit weekly goal to 100 km → Save
- [ ] Verify data persists after restart

### Test 2: Running Page (3 min)
- [ ] Navigate to Running tab
- [ ] Wait 2 seconds for weather API to load
- [ ] See current temperature and weather emoji
- [ ] See elevation below weather widget
- [ ] Scroll down to see all stats
- [ ] Tap "Enable GPS" to start tracking
- [ ] Map shows current location

### Test 3: Hiking Page (2 min)
- [ ] Navigate to Hiking tab
- [ ] Verify same features as Running page
- [ ] Check elevation is displayed correctly
- [ ] Difficulty level shows based on elevation

### Test 4: Profile Page - Photo Upload (2 min)
- [ ] Navigate to Profile tab
- [ ] Tap camera icon on avatar
- [ ] Select image from gallery
- [ ] See image displayed in profile
- [ ] Tap Edit Profile button
- [ ] Edit name to "Test User"
- [ ] Tap Save
- [ ] Verify name changed and saved

### Test 5: Search Functionality (2 min)
- [ ] Still in Profile page
- [ ] Scroll down to "SAVED ACTIVITIES"
- [ ] Save some activities (use Running/Hiking pages)
- [ ] In search bar type "running" → filter works
- [ ] Clear search, type today's date → filter works
- [ ] Click "⚡ Running" button → shows only running
- [ ] Click "All" button → shows all activities

### Test 6: Error Handling (1 min)
- [ ] Turn off WiFi/Mobile data
- [ ] Go to Running/Hiking page
- [ ] See "Error loading weather" message
- [ ] Turn back on WiFi → Try again
- [ ] Data loads successfully

---

## 🎯 What to Look For

### API Integration
✅ Weather widget shows real-time data (temp, wind, humidity)  
✅ Elevation widget shows current MDPL  
✅ Both have loading indicators while fetching  
✅ Error messages appear if internet fails  

### UI/UX
✅ Dark theme consistent across all pages  
✅ Smooth animations and transitions  
✅ Responsive layout works on different screen sizes  
✅ All buttons and icons are interactive  

### Data Persistence
✅ Weekly goal saved in SharedPreferences  
✅ Activities saved in SharedPreferences  
✅ Profile photo saved and displayed  
✅ Data persists after app restart  

### Architecture
✅ Weather/Elevation services handle API calls  
✅ Repositories provide business logic  
✅ Models handle data serialization  
✅ UI layer uses FutureBuilder for async operations  

---

## 📊 UAS Compliance Evidence

### 1. API Integration (35%)
- **Evidence:** Weather widget + Elevation widget visible in Running/Hiking pages
- **Details:** 2 working APIs with error handling

### 2. Async/Await UI (20%)
- **Evidence:** Loading spinners while APIs fetch data
- **Details:** FutureBuilder with proper error states

### 3. UI/UX Design (15%)
- **Evidence:** Professional Material Design 3 with dark theme
- **Details:** Responsive layout, search functionality, photo upload

### 4. Code Quality (30%)
- **Evidence:** Service/Repository pattern, 0 compilation errors
- **Details:** Clean architecture with proper separation of concerns

---

## 🔗 GitHub Links

- **Repository:** https://github.com/BintangS4/Mobile-Programming
- **UAS Branch:** https://github.com/BintangS4/Mobile-Programming/tree/uas/uas
- **Main Branch:** https://github.com/BintangS4/Mobile-Programming/tree/main/uts

---

## ❓ Troubleshooting

### App won't build
```bash
flutter clean
flutter pub get
flutter run
```

### APIs not responding
- Check internet connection
- Verify WiFi/Mobile data is enabled
- Check Android device has internet permission
- Wait 10 seconds for API timeout

### Image picker not working (Android)
- Ensure permissions are granted
- Check storage access permission
- Try restarting the app

### SharedPreferences not saving
- Delete app and reinstall
- Clear app cache
- Check available storage space

---

## 📞 Support

For issues or questions, refer to:
- **README.md** for detailed documentation
- **Code comments** for implementation details
- **GitHub issues** for bug reports

---

**Estimated Test Time:** 10-15 minutes  
**Difficulty Level:** Easy  
**Success Rate:** 100% if all steps followed  
