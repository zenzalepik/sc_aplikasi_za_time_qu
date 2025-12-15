# Sound Assets Folder

This folder is reserved for alarm sound files.

Currently, the alarm system uses the device's system alert sound for maximum compatibility.

If you want to add custom alarm sounds:
1. Add an MP3 or WAV file here (e.g., `beep.mp3`)
2. Update `alarm_service.dart` to use: `await _audioPlayer.play(AssetSource('sounds/beep.mp3'));`
