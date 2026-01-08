<div align="center">
  <br>
  <img src="https://capsule-render.vercel.app/api?type=waving&color=gradient&height=100&section=header&text=E-Ticaret%20Müşteri%20Uygulaması&fontSize=30&animation=fadeIn&fontAlign=50" width="100%"/>
  
  <a href="https://github.com/younessemre/eticaret_uygulamasi_admin">
    <img src="https://img.shields.io/badge/🛠️_Admin_Panelini_Gör-İNCELE-2979FF?style=for-the-badge&logo=flutter&logoColor=white&color=black&labelColor=2979FF" height="45">
  </a>
  <br><br>
</div>

<p>
    <i>Kullanıcı dostu arayüzü ile müşterilere, ürünleri hızla filtreleyip saniyeler içinde sipariş verebildikleri akıcı bir alışveriş yolculuğu sunar.</i>
  </p>

<div align="center">
  <h2>🎬 Uygulama Önizlemesi</h2>
  <img src="https://github.com/user-attachments/assets/f0d283bd-040b-4b76-b9ff-1d06a3510740" width="300" />
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
