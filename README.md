# 🌍 Country IPSet Feed

Автоматически обновляемый репозиторий с IPv4-сетями по странам для использования в `ipset` / `iptables` / firewall-скриптах.

## 📦 Что здесь хранится

- `country_ipsets/XX.txt` — список IPv4 CIDR для страны `XX` (ISO2), по одной сети на строку.
- `country_ipsets/metadata.txt` — дата обновления и источник базы.

Примеры файлов:
- `country_ipsets/RU.txt`
- `country_ipsets/BY.txt`
- `country_ipsets/AE.txt`

---

## ⚙️ Как обновляется

Обновление выполняется через **GitHub Actions** по расписанию и вручную (`Run workflow`).

Workflow:
- скачивает GeoLite2 Country MMDB,
- генерирует country-файлы,
- коммитит изменения в репозиторий.

---

## 🔗 Как использовать

Используйте Raw URL нужной страны в своих скриптах.

Пример:
- `https://raw.githubusercontent.com/<user>/<repo>/main/country_ipsets/RU.txt`

Дальше этот файл можно импортировать в `ipset` или использовать для локальной генерации правил.

---

## 🧩 Формат файлов

- Только IPv4 CIDR
- Одна сеть на строку
- Без JSON/CSV
- Подходит для прямой загрузки в shell-скрипты

---

## 🛡️ Назначение

Репозиторий работает как **публичный feed** для сетевых фильтров:
- geo-allowlist,
- country-based firewall rules,
- автоматизация обновления списков стран без ручной работы.

---

## 🕒 Частота обновления

По cron в GitHub Actions (см. `.github/workflows/update-country-ipsets.yml`)  
и вручную через кнопку **Run workflow**.

---

## ✅ Проверка после обновления

- workflow в Actions завершился `Success`
- в `country_ipsets/` есть актуальные файлы стран
- `metadata.txt` содержит свежий `updated_at_utc`
