# Viikko 3: palvelimen tilaraportti

Bash-skripti kerää palvelimen tiedot ja tekee niistä nettisivun kerran minuutissa.

Sivu: http://195.148.20.88/viikko3/

## Miten se toimii

1. `status.sh` kerää tiedot komennoilla `date`, `uptime -p`, `df /` ja `free --mega`.
2. Funktio `DISK` päättää levyn tilan: alle 80 % on OK, 80 % tai enemmän on WARNING.
3. `sed` täyttää pohjan `template.html` paikkamerkit (esim. `{{TIME}}`) ja kirjoittaa tuloksen tiedostoon `/var/www/html/viikko3/index.html`.
4. systemd-ajastin ajaa skriptin joka minuutti.

## Tiedostot

| Tiedosto | Mitä |
|---|---|
| `status.sh` | Skripti |
| `template.html` | Sivun pohja ja dokumentaatio |
| `systemd/status-report.service` | Ajaa skriptin kerran |
| `systemd/status-report.timer` | Käynnistää palvelun joka minuutti |

## Käyttöönotto

```bash
sudo mkdir -p /var/www/html/viikko3
sudo chown ubuntu:ubuntu /var/www/html/viikko3

sudo cp viikko3/systemd/status-report.service viikko3/systemd/status-report.timer /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now status-report.timer
```

Sivun gif-kuvat eivät ole repossa. Ne ovat palvelimella kansiossa `/var/www/html/viikko3/static/gifs/`.
