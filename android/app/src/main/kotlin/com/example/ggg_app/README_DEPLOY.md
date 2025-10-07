# GGG Contractor Web — quick notes (v17/v21)

## What’s working
- Contractor list + detail
- Demo mode toggle (flask icon): ON shows mock jobs & pink banner
- Actions: Accept → Arrive → (add 2 photos) → Complete
- Notes field visible on Job Detail
- Build verified string: **Contractor v20**
- Live path: `https://gogarbagegrabber.com/app/v17/`

## Build (local)
```bash
cd "/Users/toddchild/Desktop/ggg_app"
flutter clean
flutter pub get
flutter build web --base-href /app/v17/ --pwa-strategy=none
