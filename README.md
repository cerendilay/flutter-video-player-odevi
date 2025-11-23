# odev6

# Flutter Video Oynatici Uygulamasi

Bu proje, Mobil Programlama dersi odevi kapsaminda gelistirilmis; gelismis medya kontrol ozelliklerine, oynatma listesi destegine ve kullanici dostu arayuze sahip bir video oynatici uygulamasidir.

## Proje Ozellikleri

Uygulama, temel video oynatma islevlerinin yani sira kullanici deneyimini artiran ekstra ozelliklerle donatilmistir:

### Temel Ozellikler
- Video Kontrolu: Oynat (Play) ve Duraklat (Pause) islevleri.
- Ilerleme Cubugu (Slider): Videonun istenilen saniyesine anlik gecis (Seek).
- Sure Takibi: Gecen sure ve toplam sure gosterimi (Orn: 00:12 / 02:45).
- Hizli Sarma: 10 saniye ileri ve 10 saniye geri sarma butonlari.

### Gelismis Ozellikler (Bonus)
- Oynatma Listesi (Playlist): Birden fazla video arasinda ("Kelebek" ve "Ari") gecis yapabilme.
- Poster Destegi: Video baslamadan once ilgili videoya ait kapak gorselinin gosterilmesi.
- Akilli Hareketler (Gestures):
  - Cift Tiklama: Videoyu durdurur veya baslatir.
  - Dikey Kaydirma (Swipe): Ekran uzerinde parmaginizi yukari/asagi kaydirarak ses seviyesini ayarlayabilirsiniz.
- Dongu (Loop) Modu: Videonun bitince otomatik basa sarmasi.
- Sessize Alma (Mute): Tek tusla sesi kapatip acma.
- Tam Ekran (Fullscreen): Videoyu odaklanmis modda izleme imkani.
- Ozel Tasarim: Bebek pembesi tema ve ozellestirilmis ikonlar.

## Kullanilan Teknolojiler

- Flutter SDK
- Dart Dili
- Paket: video_player: ^2.9.1

## Kurulum ve Calistirma

Projeyi kendi bilgisayarinizda calistirmak icin su adimlari izleyin:

1. Projeyi klonlayin veya indirin.
2. Terminali proje dizininde acin.
3. Gerekli paketleri yukleyin:
   flutter pub get
4. Uygulamayi emulator veya cihazda baslatin:
   flutter run

## Mimari Notlar

- State Management: StatefulWidget kullanilarak video durumu (oynuyor/durdu, ses seviyesi, sure) anlik olarak yonetilmistir.
- Async Operations: Video yukleme islemleri FutureBuilder ile yonetilmis, yukleme sirasinda kullaniciya bekleme simgesi gosterilmistir.
- Resource Management: Video degistirme islemlerinde bellek sizintisini onlemek icin eski controller dispose edilmis (silinmis), yenisi yuklenirken guvenli bir gecis (resetleme) mantigi kurulmustur.

