# wonkru_mdm_server

Serverpod tabanlı Wonkru MDM arka ucu. Bu dosya operatör notlarını tutar.

## Operasyon / Ortam değişkenleri

Parantez içindeki değer varsayılandır.

- `PASSWORD_HASH_PEPPER` — **zorunlu**. Politika admin parolalarının ve 2FA
  kurtarma kodlarının Argon2 pepper'ı; TOTP sırlarının AES anahtarı da bundan
  türetilir. Parola hash'leyici yalnızca bu ortam değişkenini okur
  (`passwords.yaml` içindeki `passwordHashPepper`'a düşmez); tanımlı değilse
  2FA kurulumu ve politika parolası kaydı `StateError` ile başarısız olur,
  cihazdaki IT sayfası girişi reddedilir. Geliştirmede de verin. Panel
  kullanıcılarının giriş parolaları bundan etkilenmez (onları Email IDP
  `emailSecretHashPepper` ile yönetir). Argon2'ye geçilmeden önce bu Dart
  sunucusu gömülü `wonkru-mdm` pepper'ını kullanıyordu; o pepper'la üretilmiş
  hash'leriniz varsa `PASSWORD_HASH_PEPPER=wonkru-mdm` verin ya da politika
  parolasını panelden yeniden kaydedin. Pepper'ı sonradan değiştirmek mevcut
  Argon2 hash'lerini ve TOTP sırlarını geçersiz kılar.
- `APP_URL` — (`http://localhost:8090`). Provisioning QR'ındaki `server_url`;
  ajanın bağlanacağı API adresi. Üretimde API'nin dış adresini verin.
- `APP_NAME` — (`Wonkru MDM`). Panel marka adı ayarı boşsa kullanılan ad;
  uyarı e-postalarının konu önekinde görünür.
- `CLIENT_IP_SOURCE` — (`socket`). Rate limit'in istemci IP'sini nereden
  okuyacağı: `socket`, `proxy` (`X-Forwarded-For` / `Forwarded`) veya
  `cloudflare` (`CF-Connecting-IP`). Reverse proxy arkasında `proxy` verin;
  yoksa bütün istemciler proxy IP'sinden geliyor görünür ve giriş/kayıt
  limitleri herkesi birlikte keser.
- `DEVICE_UPLOAD_MAX_SIZE_KB` — (`51200`, yani 50 MiB). Yalnızca panel ayar
  formundaki cihaz yükleme sınırının varsayılanını besler. Ayar hiç
  kaydedilmemişse sunucu sabit 51200 KB uygular.
- `LOCAL_CA_PATH` — (`certs/local-ca.crt`). `GET /downloads/local-ca` rotasının
  servis ettiği CA PEM dosyasının yolu. Dosya yoksa rota 404 döner.
- `storageSigningKey` (passwords.yaml, ya da
  `SERVERPOD_PASSWORD_storageSigningKey` ortam değişkeni) — **üretimde
  önerilir**, en az 32 karakter rastgele değer. Gizli diskteki dosyaların
  (sertifikalar, cihaz yüklemeleri, gizli dosyalar) imzalı indirme
  bağlantıları bu sırdan türetilen anahtarla imzalanır; böylece policy'deki
  7 günlük bağlantılar yeniden başlatmada geçerli kalır ve tüm örneklerde aynı
  değer verilmelidir. Tanımsızsa `jwtHmacSha512PrivateKey`'den türetilir
  (üretim/staging'de açılışta uyarı yazılır); o da yoksa süreç başına rastgele
  anahtar kullanılır. Değiştirmek dağıtılmış imzalı bağlantıları geçersiz kılar
  (cihazlar sonraki policy çekişinde yenisini alır).
- `STORAGE_PATH` — (`storage`; Docker imajında `/app/storage`). Yüklenen
  dosyaların kökü. Kalıcı bir birim (volume) bağlanmazsa konteyner yeniden
  oluşturulduğunda dosyalar kaybolur.
- `SERVERPOD_PASSWORD_<anahtar>` — `passwords.yaml`'daki herhangi bir anahtarı
  ezer. Docker imajı `passwords.yaml` içermez (`.dockerignore`); üretimde
  sırları bu yolla verin.
- Bootstrap CA rotası (`/downloads/local-ca`) ajan tarafından kendi server
  adresinin origin'inden (aynı şema/host/port) çağrılır; ayrı bir indirme
  portu ayarı yoktur.

### Yönetici iki adımlı doğrulama (2FA) — operatör çalışma kılavuzu

Yöneticiler panelin **Profil** sayfasından TOTP tabanlı 2FA kurar
(RFC 6238; Google Authenticator uyumlu, SHA-1/6 hane/30 sn). 2FA etkinken
**hiçbir admin ucu** — parola/e-posta değiştirme dahil — ikinci adım
doğrulanmadan çalışmaz; doğrulama oturum bazlıdır (`admin_totp_sessions`),
yani bir cihazdaki kod girişi başka bir oturumu açmaz.

**Kayıp cihaz / kurtarma kodu**

1. Yöneticinin kayıtlı bir **kurtarma kodu** varsa: panelde giriş sonrası kod
   adımına kodu yazması yeterlidir. Her kod **tek kullanımlıktır** ve
   kullanılınca tüketilir.
2. Hem cihaz hem de kurtarma kodları kayıpsa panelden erişim yoktur. Bunu
   yalnızca veritabanına erişimi olan bir operatör açabilir; sunucu bir "arka
   kapı" sunmaz (2FA'yı yalnızca kodu bilen ya da DB'ye erişen kişi kaldırır):

   ```sql
   -- 1) Disable 2FA without changing the password or account
   UPDATE "admin_profiles"
      SET "totpSecret" = NULL,
          "recoveryCodes" = NULL,
          "totpLastUsedCounter" = NULL,
          "totpFailedAttempts" = 0,
          "totpLockedUntil" = NULL,
          "updatedAt" = now()
    WHERE "userId" = '<auth user uuid>';

   -- 2) Clear pending session verifications
   DELETE FROM "admin_totp_sessions" WHERE "userId" = '<auth user uuid>';
   ```

   Ardından yönetici normal parolasıyla giriş yapıp panelden **2FA Kur** ile
   yeni bir sır üretir. Eski authenticator girdisi artık çalışmaz.
3. Kilitlenme (`Çok fazla hatalı deneme`): art arda 5 hatalı denemeden sonra
   hesap kilitlenir; süre 30 sn'den başlayıp her hatalı denemede ikiye katlanır
   ve **en fazla 15 dk** kalır (çok sayıda denemede de kilit pozitif kalır).
   Beklemek dışında bir işlem gerekmez; gerekirse yukarıdaki
   `totpFailedAttempts` / `totpLockedUntil` sıfırlaması kilidi hemen açar.

**Yayın notu (`admin_totp_sessions.userId`):** `userId` sütunu sonradan
eklendi; olası eski satırlar **sıfır UUID'sine** doldurulur. Yani bu sürümden
**önce** 2FA kullanılmışsa, eski oturum satırları `clearVerification`'ın
`userId` bazlı silmesine takılmaz. Yalnızca yayın öncesi 2FA kullanıldıysa
ilgilidir; ilgili satırları elle silin ya da süreleri geçince
`purgeExpiredVerifications` temizler.

**Sırların saklanması:** TOTP sırrı `PASSWORD_HASH_PEPPER`'dan türetilen
AES-256-GCM anahtarıyla **şifreli** (`totpSecret`), kurtarma kodları Argon2id
hash'i olarak saklanır. Pepper değiştirilirse mevcut TOTP sırları çözülemez ve
2FA kırılır — pepper'ı değiştirmeden önce 2FA'yı kapatın.

### Doğrulama e-postaları (kayıt / parola sıfırlama)
E-posta IDP'sinin doğrulama kodları, `settings` tablosunda SMTP etkinse
(`smtp_enabled` açık ve `smtp_host` boş değil) `SmtpMailService` üzerinden
gönderilir. SMTP ayarı yoksa mevcut Serverpod Cloud davranışı korunur:
geliştirme/test modunda kod konsola yazılır, staging/üretimde Serverpod Cloud
e-posta servisi kullanılır — bu da `scloudAuthEmailKey` parolasını gerektirir
ve Serverpod Cloud'a dağıtılmayan kendi sunucusunda yoktur. Yani kendi
sunucunuzda kayıt/parola sıfırlama e-postasının gitmesi için panelden SMTP
ayarlarını açın.

SMTP gönderimi en iyi çabadır: bir SMTP hatası kayıt veya parola sıfırlama
akışını kesmez, yalnızca sunucu loglarına düşer (30 saniyelik üst sınırla).
Ayarların doğru olduğunu panelin SMTP test postasıyla doğrulayabilirsiniz.

SMTP kullanımı panelin `settings` tablosundaki `smtp_enabled` + `smtp_host`
değerleriyle belirlenir. Aşağıdaki ortam değişkenleri yalnızca **yedek**
(fallback) değerlerdir; panel alanı boş bırakıldığında kullanılır:

- `MAIL_MAILER` — (`log`). Varsayılan mailer adı; yalnızca panelin
  "SMTP seçili değil" uyarısında kullanılır.
- `MAIL_HOST` — (`127.0.0.1`). Panelde `smtp_host` boşsa kullanılan sunucu.
- `MAIL_PORT` — (`587`).
- `MAIL_USERNAME` / `MAIL_PASSWORD` — (`boş`). SMTP kimlik bilgileri.
- `MAIL_SCHEME` — (`boş`). `ssl` ise TLS kullanılır.
- `MAIL_FROM_ADDRESS` — (`hello@example.com`). Panelde gönderen adres boşsa.
- `MAIL_FROM_NAME` — (`Example`). Panelde gönderen ad boşsa.

### İlk kurulum (yeni dağıtım)

Halka açık **yönetici** kaydı yoktur: e-posta IDP'si hesap oluşturmaya izin
verir, ama aktif bir `AdminProfile` olmadan hiçbir admin ucu çalışmaz. Açılışta admin ya da demo verisi tohumlanmaz.

Sistemde hiç `AdminProfile` yokken `adminAuth.me()` `needsBootstrap: true`
döner ve panel giriş ekranında "İlk admini kur" formunu gösterir.
`adminAuth.bootstrap` **sır istemez**; tek korumalar "zaten bir profil varsa
reddet" kontrolü ve IP başına 20 istek / 10 dk sınırıdır. Yani yeni bir
dağıtımda ilk yönetici kurulana kadar panel adresine ilk ulaşan kişi yönetici
olabilir.

Kurulum yolu:

1. Sunucuyu ilk açtığınızda panel adresine erişimi kısıtlayın (IP izin
   listesi, VPN ya da proxy'de geçici basic auth).
2. Panelden "İlk admini kur" ile yöneticiyi oluşturun, giriş yapıp
   **Profil**'den 2FA'yı açın.
3. Kısıtlamayı kaldırın. Diğer yöneticileri panelin **Kullanıcılar**
   sayfasından ekleyin.

## Çalıştırma

Geliştirme (gömülü PostgreSQL, migration'lar açılışta uygulanır, panel
`http://localhost:8099`'da açılır):

    cd wonkru_mdm_server
    serverpod start

`Q` ile kapatılır.

Üretim imajı repo kökünden derlenir; önce paneli `web/app`'e derleyin:

    cd wonkru_mdm_server && serverpod run flutter_build
    cd .. && docker build -f wonkru_mdm_server/Dockerfile -t wonkru-mdm-server .

İmaj bekleyen migration'ları açılışta uygular (`--apply-migrations`).

## Cihaz kaydı ve depolama güvenliği

- **Kayıt anahtarı:** `device.register` global bir kayıt anahtarı ister
  (`settings.device_enrollment_key`, ilk ihtiyaçta üretilir). Panel > Ayarlar >
  Cihaz Kayıt Anahtarı'ndan görülür/yenilenir. Provisioning QR'ları anahtarı
  `enrollment_key` ekstrasıyla okunduğu anda taşır (profilde saklanmaz).
  Yenileme kayıtlı cihazları etkilemez; eski QR ile yeni kayıt reddedilir
  (`DeviceEnrollmentRejectedException`).
- **Cihaz token'ı:** DB'de yalnız SHA-256'sı (`devices.authToken`, panel
  görmez) tutulur; düz token yalnız kayıt yanıtında bir kez döner.
- **Gizli disk:** Sertifikalar ve cihaz yüklemeleri `storage/private` altına
  yazılır, yalnız imzalı süreli bağlantıyla iner. Açık disk rotası bu
  klasörleri hiç servis etmez.
