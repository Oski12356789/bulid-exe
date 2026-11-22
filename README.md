# AI Offline Instalator

Mały instalator Windows. Podczas instalacji pobiera z internetu Ollama, Visual Studio Code, rozszerzenie Cline oraz model `qwen2.5-coder:7b`.

## Budowanie EXE przez GitHub Actions

1. Utwórz puste repozytorium GitHub.
2. Wgraj wszystkie pliki z tego archiwum, zachowując strukturę katalogów.
3. Otwórz kartę Actions i uruchom workflow `Build Windows Installer`.
4. Po zakończeniu pobierz artifact `AI-Offline-Instalator-Windows`.
5. W środku znajdziesz `AI-Offline-Instalator-Setup.exe`.

Wymagania: Windows 10/11, internet podczas instalacji, Windows Package Manager (`winget`) oraz kilka GB wolnego miejsca na model. Zalecane 16 GB RAM.

## Konfiguracja Cline

W VS Code otwórz Cline i wybierz:
- Provider: Ollama
- Base URL: `http://localhost:11434`
- Model: `qwen2.5-coder:7b`

Model działa lokalnie po pobraniu. Na i3-1215U może działać wolno. Cline może edytować pliki i uruchamiać polecenia, więc zatwierdzaj tylko zaufane działania.
