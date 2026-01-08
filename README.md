# 🛍️ Ultimate E-Commerce App (Flutter & Firebase)

Flutter ve Firebase altyapısı kullanılarak geliştirilmiş, **MVVM** mimarisine ve **Clean Architecture** prensiplerine uygun, ölçeklenebilir bir E-Ticaret müşteri uygulamasıdır.

Bu proje, sadece bir arayüz çalışması değil; Authentication, State Management, Database ve Storage işlemlerini içeren canlı bir ekosistemdir.

---

<div align="center">
  <h2>🎬 Uygulama Önizlemesi</h2>
  <img src="https://github.com/user-attachments/assets/f0d283bd-040b-4b76-b9ff-1d06a3510740" width="300" />
  <p>
    <i>Müşterilerin ürünleri keşfedip, sepete ekleyerek sipariş verdiği akıcı mobil deneyim.</i>
    <br><br>
    <small>💡 <b>Sistem Notu:</b> Bu projenin ürün ve sipariş yönetimi için geliştirilen <b><a href="https://github.com/younessemre/eticaret_uygulamasi_admin">Admin Paneli (Yönetici)</a></b> projesini ayrıca inceleyebilirsiniz.</small>
  </p>
</div>

---

## ✨ Temel Özellikler

* **🔐 Güvenli Kimlik Doğrulama:** Email/Şifre ve **Google Sign-In** ile güvenli giriş (Firebase Auth).
* **☁️ Gerçek Zamanlı Veritabanı:** Ürünler, kategoriler ve kullanıcı verileri **Cloud Firestore** üzerinden anlık senkronize edilir.
* **🛒 Gelişmiş Sepet & Favori Yönetimi:** `Provider` kullanılarak tüm uygulama genelinde senkronize çalışan sepet ve wishlist mantığı.
* **🔍 Akıllı Arama ve Filtreleme:** Ürün ismine veya kategorisine göre dinamik arama yapabilme.
* **🖼️ Optimize Görseller:** `Fancy Shimmer Image` ile görseller yüklenirken profesyonel placeholder efektleri.
* **📦 Sipariş Simülasyonu:** Sepet onaylama ve sipariş oluşturma süreçleri.

## 🛠️ Teknik Mimari ve Kullanılan Teknolojiler

Proje, sürdürülebilirlik ve performans için modern teknolojilerle donatılmıştır:

| Kategori | Teknoloji / Kütüphane |
| :--- | :--- |
| **Dil** | Dart (Flutter SDK) |
| **State Management** | Provider (Verimli UI rebuild yönetimi) |
| **Backend** | Firebase (Auth, Firestore, Storage) |
| **Mimari** | MVVM / Clean Architecture |
| **UI Kit** | Iconly, Card Swiper, Flutter Toast |
| **Görsel İşleme** | Fancy Shimmer Image, Image Picker |

## 📂 Proje Klasör Yapısı

Kod okunabilirliğini artırmak için modüler bir yapı tercih edilmiştir:

* `providers/`: Uygulamanın tüm durum yönetimi (Cart, Product, User, Wishlist logic).
* `models/`: JSON verilerini işleyen güvenli veri modelleri.
* `services/`: Firebase ve global metodların yönetildiği servis katmanı.
* `screens/`: Kullanıcı arayüzü sayfaları (Auth, Cart, Home, vb.).
* `widgets/`: Tekrar kullanılabilir, modüler UI parçaları.

## 🚀 Kurulum ve Çalıştırma

Projeyi yerel makinenizde çalıştırmak için adımları izleyin:

1.  **Projeyi Klonlayın:**
    ```bash
    git clone [https://github.com/KULLANICI_ADIN/ecommerce-flutter.git](https://github.com/KULLANICI_ADIN/ecommerce-flutter.git)
    ```
2.  **Paketleri Yükleyin:**
    ```bash
    flutter pub get
    ```
3.  **Firebase Kurulumu:**
    * Kendi `google-services.json` dosyanızı `android/app/` klasörüne ekleyin.
4.  **Başlatın:**
    ```bash
    flutter run
    ```

---
*Geliştirici: [Senin Adın]*
