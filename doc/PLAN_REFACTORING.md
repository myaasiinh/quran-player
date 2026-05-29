# 🏗️ Refactoring & Optimization Plan: Quran Player (Phase 2)

**Goal:** Elevate codebase quality to Principal/Staff Engineer standards by removing technical debt (unused boilerplate), modularizing UI, implementing full localization, and ensuring 100% critical path test coverage.

---

## 🧹 1. Technical Debt Cleanup
Remove all unused features from the initial boilerplate to reduce binary size and cognitive load.

**Scope of Deletion:**
- `lib/ui/views/*` EXCEPT `quran` and `404_500`.
- `lib/data/repositories/*` EXCEPT `quran`.
- `lib/data/sources/server/*` EXCEPT `quran`.
- `test/data/repositories/*` EXCEPT `quran_repository_test.dart`.
- `test/ui/widgets/buku/`.

---

## 🌍 2. Global Localization (.tr)
Adherence to `AI_PROMPTING_GUIDELINES.md` Section 9.3.

**Hardcoded Strings to Translate:**
- `Al-Quran` -> `quran_title`
- `Search Surah...` -> `search_surah_hint`
- `Detail Surah` -> `surah_detail_title`
- `Meccan` -> `meccan`
- `Medinan` -> `medinan`
- `Ayahs` -> `ayahs`

---

## 🧩 3. UI Architecture: Widget Reusability
Decouple `SurahDetailView` into atomic, reusable widgets.

**New Structure:**
- `lib/ui/views/quran/surah_detail/widgets/`:
    - `ayah_item_tile.dart`: Individual verse display logic.
    - `player_control_panel.dart`: Playback UI and progress bar logic.

---

## 🧪 4. Comprehensive Testing Strategy
Follow the "Plan -> Act -> Validate" cycle for all architectural layers.

**Test Targets:**
1.  **Controller Layer**:
    - `SurahListControllerTest`: Verify search logic and data fetching state transitions.
    - `SurahDetailControllerTest`: Verify audio player state management and playlist setup.
2.  **View Layer (Widget Tests)**:
    - `SurahListViewTest`: Verify search filtering and empty state.
    - `SurahDetailViewTest`: Verify play/pause button interaction and ayah navigation.
3.  **Repository Layer**:
    - `QuranRepositoryTest`: (Expand) Verify caching behavior and API failure mapping.

---

## 📝 5. Definition of Done (DoD)
1. [ ] Zero unused boilerplate files remaining.
2. [ ] No hardcoded strings in the View layer.
3. [ ] `SurahDetailView` is composed of 2+ sub-widgets.
4. [ ] All Controllers, Views, and Repositories have associated tests.
5. [ ] `make analyze` and `flutter test` pass with 0 errors.

---
*"Architecture is the art of what to leave out."*
