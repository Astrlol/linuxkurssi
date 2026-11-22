# Viikko 4: varmuuskopiot ja replikointi

Kaksi palvelinta:
- **A** (`nuuttilinux`): viikon 2 laskuri ja sen tietokanta
- **B** (`gigalinux`): tehty A:n snapshotista

B tekee kaksi asiaa:
- **Varmuuskopio:** ottaa A:n kansiosta `/var/www/html` kopion joka tunti (cron).
- **Replikointi:** sen MySQL on A:n MySQL:n jatkuva kopio, jota ei voi muokata.

B:n sivu `/viikko4/` näyttää laskurin B:n omasta kopiosta muuttamatta mitään.

Sivut:
- A, laskuri: http://195.148.20.88/viikko2/
- B, vain luku: http://86.50.20.212/viikko4/

## Tiedostot

| Tiedosto | Mitä | Palvelin |
|---|---|---|
| `nettisivun-varmuuskopiointi.sh` | Varmuuskopioskripti. Asennetaan polkuun `/usr/local/bin/nettisivun-varmuuskopiointi`. | B |
| `etc/cron.d/nettisivun-varmuuskopiointi` | Ajastus: joka tunti minuutilla 15, käyttäjänä `varmuuskopio` | B |
| `mysql/replikointi-a.cnf` | MySQL-asetukset, lähde | A |
| `mysql/replikointi-b.cnf` | MySQL-asetukset, replika ja vain luku | B |
| `mysql/replikointi.sql` | Käyttäjät ja replikoinnin käynnistys. Salasanojen tilalla paikkamerkit. | A ja B |
| `kopiolaskuri.py` | Sivun sovellus. Tekee vain `SELECT`-kyselyn. | B |
| `templates/index.html` | Sivun pohja ja dokumentaatio | B |
| `etc/systemd/system/replikasivu.service` | Sovelluksen systemd-palvelu | B |
| `etc/nginx/viikko4.conf` | Nginx-lohko osoitteelle `/viikko4/` | B |
| `viikko4.env.example` | Malli tunnuksille. Oikea tiedosto on B:llä `/etc/viikko4.env`. | B |

## Varmuuskopio lyhyesti

- Cron ajaa skriptin joka tunti käyttäjänä `varmuuskopio`.
- Skripti hakee A:lta `tar.gz`-arkiston SSH:n yli sisäverkossa.
- Arkistot tallentuvat kansioon `/srv/varmuuskopiot/nettisivu/` (oikeudet `700`, tiedostot `600`).
- Jokaisesta ajosta kirjataan OK tai FAIL tiedostoon `/srv/varmuuskopiot/varmuuskopio.log`.
- 24 uusinta arkistoa säilytetään.

## Replikointi lyhyesti

- MySQL 8.4, GTID-replikointi salatulla yhteydellä.
- A on lähde (`server-id 1`), B on replika (`server-id 2`).
- B:llä on käytössä `read_only` ja `super_read_only`: vain replikointi voi kirjoittaa.
- Sivu lukee tietokantaa käyttäjänä `lukija`, jolla on pelkkä `SELECT`-oikeus.

## Ei repossa

Salasanat, SSH-avaimet, varmuuskopioarkistot, SQL-dumpit ja gif-kuvat.
