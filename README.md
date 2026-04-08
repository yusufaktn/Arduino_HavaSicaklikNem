# 🌡️ Arduino Hava Sıcaklık & Nem Takip Sistemi

Bu proje, ESP8266 ve sıcaklık-nem sensörü kullanarak ortam verilerini ölçen ve bu verileri Flutter ile geliştirilen mobil uygulama üzerinden gerçek zamanlı olarak kullanıcıya sunan bir IoT uygulamasıdır.

---

## 📌 Proje Amacı

Amaç, düşük maliyetli bir donanım ile ortam sıcaklık ve nem değerlerini anlık olarak izleyebilen, mobil cihazlar üzerinden erişilebilir bir sistem geliştirmektir.
Bu proje, IoT (Internet of Things) ve mobil uygulama entegrasyonuna pratik bir örnek sunar.

---

## ⚙️ Kullanılan Teknolojiler

### Donanım

* ESP8266 (Wi-Fi destekli mikrodenetleyici)
* Sıcaklık ve Nem Sensörü (DHT11 / DHT22)

### Yazılım

* Flutter (Mobil uygulama geliştirme)
* Arduino IDE (ESP8266 programlama)
* HTTP / REST API veya WebSocket

---

## 🚀 Özellikler

* 📡 Gerçek zamanlı sıcaklık ve nem verisi takibi
* 🌐 ESP8266 üzerinden kablosuz veri gönderimi
* 📱 Flutter mobil uygulama ile kullanıcı dostu arayüz
* 🔄 Anlık veri güncelleme
* 🧩 Modüler ve geliştirilebilir yapı

---

## 🏗️ Sistem Mimarisi

* Sensör ortamdan sıcaklık ve nem verisini toplar
* ESP8266 bu veriyi işler ve internet üzerinden gönderir
* Flutter uygulaması bu veriyi alır ve kullanıcıya gösterir

```
[Sensör] → [ESP8266] → [İnternet] → [Flutter Mobil Uygulama]
```

---

## 📲 Uygulama Özellikleri

* Anlık sıcaklık ve nem değerlerini görüntüleme
* Basit ve anlaşılır kullanıcı arayüzü
* Genişletilebilir yapı (grafik, geçmiş veri, bildirim vb. eklenebilir)

---

## 🔧 Kurulum

### Donanım Kurulumu

* Sensörü ESP8266’ya bağlayın
* Gerekli pin bağlantılarını yapın

### ESP8266 Kod Yükleme

* Arduino IDE üzerinden ESP8266’ya kod yükleyin
* Wi-Fi bilgilerinizi tanımlayın

### Mobil Uygulama

```bash
flutter pub get
flutter run
```

---

## 📈 Geliştirme Fikirleri

* 📊 Geçmiş verileri grafik olarak gösterme
* 🔔 Sıcaklık/Nem eşiklerine göre bildirim sistemi
* ☁️ Cloud entegrasyonu (Firebase, Supabase vb.)
* 👥 Çoklu cihaz desteği

