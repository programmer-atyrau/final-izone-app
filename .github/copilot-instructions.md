<!-- .github/copilot-instructions.md -->
# Copilot / AI agent instructions — AR Tourist App

Цель: кратко и конкретно дать AI-агентам всё необходимое для быстрой продуктивной работы в этом Flutter-проекте.

- Проект: Flutter (Dart 3.0+, Flutter SDK 3.8.1+). Сборка и запуск через `flutter` (см. `pubspec.yaml`).
- Быстрая активация:
  - flutter pub get — подтянуть зависимости (см. `pubspec.yaml`).
  - flutter run -d <device> — запустить на устройстве/эмуляторе (например `flutter run -d windows` или `flutter run -d emulator-5554`).
  - flutter test — прогон тестов (в корне `test/widget_test.dart`).

Ключевые места в кодовой базе
- Точка входа: `lib/main.dart` — использует MaterialApp.router и `routerConfig: AppRouter.router`.
  - Изменять навигацию через: `lib/utils/app_router.dart` (go_router).
- UI/экранная структура: `lib/screens/` — все экраны (splash, auth, home, route, scan, map, profile, model_viewer_screen и т.д.).
- Компоненты: `lib/widgets/` — повторно используемые виджеты.
- Бизнес-логика / интеграции: `lib/services/` — сетевые вызовы, репозитории, провайдеры состояния.
- Модели данных: `lib/models/`.
- Ресурсы: `assets/images/`, `assets/models/` (.glb для 3D), `assets/icons/` — объявлены в `pubspec.yaml`.

Архитектурные паттерны и конвенции (наблюдаемое поведение)
- Навигация — декларативная через `go_router`. Добавление/редактирование маршрутов делается в `lib/utils/app_router.dart`.
- State management — проект зависит от `provider` (см. `pubspec.yaml`). Поиск `ChangeNotifier`/`Provider`-обёрток обычно в `lib/services` или в корневых виджетах.
- 3D и AR — используются `model_viewer_plus` для .glb (локальные файлы в `assets/models/` или URL). См. `lib/screens/model_viewer_screen.dart` (экран просмотра 3D-моделей).
- Сканирование и камера — `qr_code_scanner` + `permission_handler`. Проверяйте AndroidManifest и iOS Info.plist на наличие разрешений.
- Карты — `google_maps_flutter` добавлен в зависимости, но README отмечает "Реальная интеграция с Google Maps" в TODO: проверить платформенные настройки API-ключа (AndroidManifest / AppDelegate / Info.plist).

Интеграционные точки и примечания по платформам
- Google Maps: требует API ключей в платформенных файлах:
  - Android: `android/app/src/main/AndroidManifest.xml` или `android/app/src/main/res/values/google_maps_api.xml`.
  - iOS: `ios/Runner/AppDelegate.swift` / `Info.plist`.
  - README проекта содержит пометку, что интеграция может быть частичной — перед изменением карт проверьте существующие конфигурации.
- Камера/QR: проверьте разрешения в `android/app/src/main/AndroidManifest.xml` и `ios/Runner/Info.plist` — отсутствие приведёт к пустому/черному просмотру при сканировании.
- 3D модели: `model_viewer_plus` может требовать корректного пути к ресурсу. В проекте модели лежат в `assets/models/` и доступны через `Asset` пути, либо как URL.

Наглядные примеры задач и где править
- Добавить новый экран: создать файл в `lib/screens/`, зарегистрировать маршрут в `lib/utils/app_router.dart`.
- Подключить новый .glb: положить файл в `assets/models/`, убедиться, что путь совпадает с `pubspec.yaml`, и использовать `ModelViewer` в `model_viewer_screen.dart`.
- Добавить сетевой сервис: добавить файл в `lib/services/`, описать класс/интерфейс и зарегистрировать/внедрить через `Provider` (искать существующие примеры в `lib/services`).

Команды разработки и отладка (полезное)
- Установка зависимостей: `flutter pub get`.
- Запуск на Windows: `flutter run -d windows`.
- Запуск на Android (эмулятор/устройство): `flutter run -d <deviceId>`.
- Сборка APK: `flutter build apk --release`.
- Логи во время запуска: `flutter run --verbose`.
- Прогон тестов: `flutter test`.

Частые ловушки, найденные в проекте
- Карты могут показывать пустую область без API-ключа или при неверной конфигурации платформы.
- QR/камера не будет работать без runtime-разрешений и соответствующих манифестов.
- 3D-модели: относительные/локальные пути отличаются от URL — проверяйте используемый конструктор `ModelViewer`.

Поиск знаний в кодовой базе
- Если нужен пример навигации — откройте `lib/utils/app_router.dart` и `lib/main.dart`.
- Если нужно понять данные/модели — смотрите `lib/models/` и места использования в `lib/screens/`.
- Если нужно понять внешние вызовы — ищите `http`/`http.get`/`http.post` в `lib/services/`.

Когда просить у разработчика дополнительные данные
- API-ключи (Google Maps, картография) — не храните их в репозитории; попросите тестовые ключи или инструкции по установке в CI.
- Локальные .glb-исходники, если необходимо добавить новые 3D-модели.

Если нужно расширить этот файл — скажите, на какие задачи (например: подготовить чек-лист для релиза Android/iOS, добавить примеры unit/widget тестов, или показать точные места, где Provider создаётся).
