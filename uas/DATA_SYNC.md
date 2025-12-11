# Data Synchronization Architecture

## Overview
Home Page data now syncs dynamically with Profile Page edits using SharedPreferences as the persistence layer.

## Architecture

```
EditProfilePage (Save Data)
        ↓
    UserService.saveUserData()
        ↓
    SharedPreferences
        ↓
    ProfilePage (Load on init)
    HomePage (Load on init)
```

## Components

### 1. UserService (`lib/services/user_service.dart`)
Central service for managing user data persistence.

**Key Methods:**
- `getUserName()` - Load user name from SharedPreferences
- `getUserInitials()` - Load user initials from SharedPreferences
- `getUserLevel()` - Load user level from SharedPreferences
- `getUserImagePath()` - Load user image path from SharedPreferences
- `saveUserName()` - Save user name to SharedPreferences
- `saveUserInitials()` - Save user initials to SharedPreferences
- `saveUserLevel()` - Save user level to SharedPreferences
- `saveUserImagePath()` - Save user image path to SharedPreferences
- `saveUserData()` - Save all user data at once
- `clearUserData()` - Clear all user data

**Default Values:**
- Default Name: "Andrew"
- Default Initials: "AS"
- Default Level: "Beginner"

### 2. EditProfilePage (`lib/pages/edit_profile_page.dart`)
When user taps "Save Profile" button:
1. Validates input (name field)
2. Calls `UserService.saveUserData()`
3. Saves name, initials, and image path to SharedPreferences
4. Returns to ProfilePage with updated data
5. ProfilePage automatically updates UI

### 3. ProfilePage (`lib/pages/profile_page.dart`)
On page init:
1. Calls `_loadUserData()` in `initState()`
2. Loads name, initials, and level from UserService
3. Updates state with loaded data
4. When returning from EditProfilePage, receives updated data and refreshes UI

### 4. HomePage (`lib/pages/home_page.dart`)
On page init:
1. Calls `_loadUserData()` in `initState()`
2. Loads name, initials, and level from UserService
3. Updates state with loaded data
4. Displays user greeting with synchronized data

## Data Flow Example

### Scenario: User edits profile name from "Andrew" to "Riza"

1. **ProfilePage** → Taps "Edit Profile" → Opens **EditProfilePage**
2. **EditProfilePage** → User changes name to "Riza" → Taps "Save"
3. **_saveProfile()** method:
   - Calls `UserService.saveUserData(name: "Riza", initials: "R", imagePath: ...)`
   - Data saved to SharedPreferences
   - Returns to ProfilePage with result Map
4. **ProfilePage** receives result:
   - Updates local state: `_userName = "Riza"`
   - Updates UI to show "Riza"
5. **HomePage** - Next time user navigates to Home tab:
   - `_loadUserData()` is called if needed
   - Loads "Riza" from SharedPreferences
   - Updates greeting to "Hello, Riza"

## Data Persistence Keys

```
user_name         → User's full name
user_initials     → User's initials (auto-generated or custom)
user_level        → User's skill level (Beginner, Intermediate, Advanced, etc.)
user_image_path   → File path to user's profile image
```

## Future Enhancements

1. **Reactive Updates** - Use Provider/Riverpod for automatic UI updates across all pages
2. **Image Storage** - Copy images to app documents directory instead of using file paths
3. **Activity Sync** - Sync activities list across pages using same pattern
4. **Weekly Progress** - Calculate weekly progress from activities list
5. **Cloud Sync** - Sync user data to Firebase/Backend when internet available
6. **Offline Support** - Queue local changes for sync when connection restored
