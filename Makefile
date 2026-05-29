.PHONY: run-dev run-stg run-prod test test-golden analyze clean build-runner pigeon get

run-dev:
	flutter run --dart-define=ENV=DEV

run-stg:
	flutter run --dart-define=ENV=STG

run-prod:
	flutter run --dart-define=ENV=PROD

test:
	flutter test

test-golden:
	flutter test --update-goldens

analyze:
	flutter analyze

clean:
	flutter clean

get:
	flutter pub get

build-runner:
	flutter pub run build_runner build --delete-conflicting-outputs

pigeon:
	flutter pub run pigeon --input pigeons/privy_liveness.dart
	flutter pub run pigeon --input pigeons/video_processor.dart
